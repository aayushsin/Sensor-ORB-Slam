#include<iostream>
#include<algorithm>
#include<fstream>
#include<chrono>
#include<string>
#include <vector>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <ros/ros.h>
#include <cv_bridge/cv_bridge.h>
#include <message_filters/subscriber.h>
#include <message_filters/synchronizer.h>
#include <message_filters/sync_policies/approximate_time.h>
#include <sensor_msgs/Image.h>
#include <snowmower_msgs/DecaWaveMsg.h>
#include <anavs_rtk_dlr/odometry.h>
#include <ros/callback_queue.h>
#include <boost/bind.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <filter_synchronizer1/slamMsg.h>
#include <ros/package.h>

using namespace std;
using namespace message_filters;
static const std::string OPENCV_WINDOW1 = "Left Image window";
string path = ros::package::getPath("filter_synchronizer1");
string src_path = path.substr(0,path.find_last_of("/\\"));
string Image_path1 = src_path + "/storage/left_image_data/";
string Image_path2 = src_path + "/storage/right_image_data/";
string cali_filename = path + "/src/bumblebee2.yaml";
string range_file = src_path + "/storage/distance_data/range.txt";
string timestamp_file = src_path + "/storage/time_stamp/time_stamp.txt";
string groundtruth_file = src_path + "/storage/ground_truth/ground_truth.txt";

ros::CallbackQueue my_callback_queue;
ofstream rangelog;
ofstream timestamplog;
ofstream groundtruthlog;
std_msgs::Header last_img_header;

int Left_img_sec = 0;
int Left_img_nsec = 0;
int Right_img_sec = 0;
int Right_img_nsec = 0;
double Left_last_timestamp = 0.0;
double Right_last_timestamp = 0.0;
double range_last_timestamp = 0.0;
double Left_mean_timestamp = 0.0;
double Right_mean_timestamp = 0.0;
double test_time = 0.0;
double rtk_timestamp = 0.0;

bool hit_flag = false;       //a match hit when dataset from three topics available
int recording_image_rate = 2;  //recording rate for dataset
int counter = 0;

class MatchGrabber{
public:
  MatchGrabber(){}

  void Callback(const sensor_msgs::ImageConstPtr &msgLeft, const sensor_msgs::ImageConstPtr &msgRight);
  void Range_Callback(const snowmower_msgs::DecaWaveMsgConstPtr& message);
  void GroundTruth_Callback(const anavs_rtk_dlr::odometryConstPtr& message);
  cv::Mat M1l,M2l,M1r,M2r;
  float stored_range = 0.0;
  std::vector<double> rtk_matrix;
  ros::Publisher rover_status_pub;
  filter_synchronizer1::slamMsg rover_status;
};

void MatchGrabber::Callback(const sensor_msgs::ImageConstPtr &msgLeft, const sensor_msgs::ImageConstPtr &msgRight){
  // Copy the ros image message to cv::Mat.
  cv_bridge::CvImageConstPtr cv_ptrLeft;
  try
  {
    cv_ptrLeft = cv_bridge::toCvShare(msgLeft);
  }
  catch (cv_bridge::Exception& e)
  {
    ROS_ERROR("cv_bridge exception: %s", e.what());
    return;
  }

  cv_bridge::CvImageConstPtr cv_ptrRight;
  try
  {
    cv_ptrRight = cv_bridge::toCvShare(msgRight);
  }
  catch (cv_bridge::Exception& e)
  {
    ROS_ERROR("cv_bridge exception: %s", e.what());
    return;
  }

  cv::Mat imLeft, imRight;
  cv::remap(cv_ptrLeft->image,imLeft,M1l,M2l,cv::INTER_LINEAR);
  cv::remap(cv_ptrRight->image,imRight,M1r,M2r,cv::INTER_LINEAR);

  cv::imshow("Left Image", imLeft);
  cv::imshow("Right Image",imRight);
  cv::waitKey(2);

  cout << "Ranging measurement [m] = " << stored_range << endl;

  counter++;
  static int image_counter1 = 0; //Left Image Counter
  static int image_counter2 = 0; //Right Image Counter


  Left_img_sec = msgLeft->header.stamp.sec;
  Left_img_nsec = msgLeft->header.stamp.nsec;
  Right_img_sec = msgRight->header.stamp.sec;
  Right_img_nsec = msgRight->header.stamp.nsec;
  Left_mean_timestamp =  (Left_last_timestamp + Left_img_sec + Left_img_nsec/1e9)/2.0; //mean time stamp used by the range finder synchronization


  if (!hit_flag){
    if(Left_img_sec + Left_img_nsec/1e9-Left_last_timestamp > 0.040 && (counter%recording_image_rate==0)){
        image_counter1++;
        std::string savingName1 = Image_path1 + "Left_image" + std::to_string(image_counter1) + ".jpg";
        cv::imwrite(savingName1, imLeft);

        rover_status.range_distance = -1;
        rangelog << std::to_string(-1)<<endl;
        rover_status.image_left = *msgLeft;
        rover_status.rtk_matrix = rtk_matrix;
        for (std::vector<double>::const_iterator i = rtk_matrix.begin(); i != rtk_matrix.end(); ++i)
            groundtruthlog << *i << " ";
        groundtruthlog <<""<<endl;
        boost::posix_time::ptime my_posix_time = msgLeft->header.stamp.toBoost();
        std::string iso_time_str = boost::posix_time::to_iso_extended_string(my_posix_time);
        //timestamplog << iso_time_str <<endl;
        timestamplog << msgLeft->header.stamp.sec << "." << msgLeft->header.stamp.nsec << endl;
        rover_status.header.stamp = msgLeft->header.stamp;
        }

    if(Right_img_sec + Right_img_nsec/1e9-Right_last_timestamp > 0.040 && (counter%recording_image_rate==0)){
        image_counter2++;
        std::string savingName2 = Image_path2 + "Right_image" + std::to_string(image_counter2) + ".jpg";
        cv::imwrite(savingName2, imRight);
        rover_status.image_right = *msgRight;
        }
  }
  else {
    if (range_last_timestamp <= Left_mean_timestamp){
        boost::posix_time::ptime my_posix_time = last_img_header.stamp.toBoost();
        std::string iso_time_str = boost::posix_time::to_iso_extended_string(my_posix_time);
        //timestamplog << iso_time_str <<endl;
        timestamplog << last_img_header.stamp.sec << "." << last_img_header.stamp.nsec << endl;
        rover_status.header.stamp = last_img_header.stamp;
	    rangelog << stored_range <<endl;
	    rover_status.range_distance = stored_range;
        rover_status.rtk_matrix = rtk_matrix;
	    for (std::vector<double>::const_iterator i = rtk_matrix.begin(); i != rtk_matrix.end(); ++i)
            groundtruthlog << *i << " ";
        groundtruthlog <<""<<endl;
        if(Left_img_sec + Left_img_nsec/1e9-Left_last_timestamp > 0.040){
            image_counter1++;
            std::string savingName1 = Image_path1 + "Left_image" + std::to_string(image_counter1) + ".jpg";
            cv::imwrite(savingName1, imLeft);
            rover_status.image_left = *msgLeft;
            }
        if(Right_img_sec + Right_img_nsec/1e9-Right_last_timestamp > 0.040){
	        image_counter2++;
            std::string savingName2 = Image_path2 + "Right_image" + std::to_string(image_counter2) + ".jpg";
            cv::imwrite(savingName2, imRight);
            rover_status.image_right = *msgRight;
	        }
      }
    else {
        boost::posix_time::ptime my_posix_time = msgLeft->header.stamp.toBoost();
        std::string iso_time_str = boost::posix_time::to_iso_extended_string(my_posix_time);
        //timestamplog << iso_time_str <<endl;
        timestamplog << msgLeft->header.stamp.sec << "." << msgLeft->header.stamp.nsec << endl;
        rover_status.header.stamp = msgLeft->header.stamp;
        rangelog << stored_range <<endl;
        rover_status.range_distance = stored_range;
        rover_status.rtk_matrix = rtk_matrix;
	    for (std::vector<double>::const_iterator i = rtk_matrix.begin(); i != rtk_matrix.end(); ++i)
            groundtruthlog << *i << " ";
        groundtruthlog <<""<<endl;
	    if(Left_img_sec + Left_img_nsec/1e9-Left_last_timestamp > 0.040){
            image_counter1++;
            std::string savingName1 = Image_path1 + "Left_image" + std::to_string(image_counter1) + ".png";
            cv::imwrite(savingName1, imLeft);
            rover_status.image_left = *msgLeft;
            }
        if(Right_img_sec + Right_img_nsec/1e9-Right_last_timestamp > 0.040){
	        image_counter2++;
            std::string savingName2 = Image_path2 + "Right_image" + std::to_string(image_counter2) + ".png";
            cv::imwrite(savingName2, imRight);
            rover_status.image_right = *msgRight;
	    }
    }
    hit_flag = false;
  }
    last_img_header = msgLeft->header;
    Left_last_timestamp = Left_img_sec + Left_img_nsec/1e9;
    Right_last_timestamp = Right_img_sec + Right_img_nsec/1e9;
    rover_status_pub.publish(rover_status);
}

void MatchGrabber::Range_Callback(const snowmower_msgs::DecaWaveMsgConstPtr& message){
  hit_flag = true;
  stored_range = message->dist;
  range_last_timestamp = message->header.stamp.sec + message->header.stamp.nsec/1e9;
}

void MatchGrabber::GroundTruth_Callback(const anavs_rtk_dlr::odometryConstPtr& message){
    rtk_matrix = message ->matrix;
    rtk_timestamp = message->header.stamp.sec + message->header.stamp.nsec/1e9;
}


int main(int argc, char** argv)
{
  rangelog.open (range_file,ios::out | ios::trunc);  //  ios::app,   ios::ate ,other modes
  timestamplog.open (timestamp_file,ios::out | ios::trunc);
  groundtruthlog.open (groundtruth_file,ios::out | ios::trunc);

  ros::init(argc, argv, "stereo_ranging_rtk");
  ros::start();

  MatchGrabber igb;

  //cv::FileStorage fsSettings(string(argv[1]), cv::FileStorage::READ);
  cv::FileStorage fsSettings(cali_filename, cv::FileStorage::READ);

  if(!fsSettings.isOpened())
  {
    cerr << "ERROR: Wrong path to settings" << endl;
    return -1;
  }

  cv::Mat K_l, K_r, P_l, P_r, R_l, R_r, D_l, D_r;
  fsSettings["LEFT.K"] >> K_l;
  fsSettings["RIGHT.K"] >> K_r;

  fsSettings["LEFT.P"] >> P_l;
  fsSettings["RIGHT.P"] >> P_r;

  fsSettings["LEFT.R"] >> R_l;
  fsSettings["RIGHT.R"] >> R_r;

  fsSettings["LEFT.D"] >> D_l;
  fsSettings["RIGHT.D"] >> D_r;

  int rows_l = fsSettings["LEFT.height"];
  int cols_l = fsSettings["LEFT.width"];
  int rows_r = fsSettings["RIGHT.height"];
  int cols_r = fsSettings["RIGHT.width"];

  if(K_l.empty() || K_r.empty() || P_l.empty() || P_r.empty() || R_l.empty() || R_r.empty() || D_l.empty() || D_r.empty() ||
    rows_l==0 || rows_r==0 || cols_l==0 || cols_r==0)
  {
    cerr << "ERROR: Calibration parameters to rectify stereo are missing!" << endl;
    return -1;
  }

  cv::initUndistortRectifyMap(K_l,D_l,R_l,P_l.rowRange(0,3).colRange(0,3),cv::Size(cols_l,rows_l),CV_32F,igb.M1l,igb.M2l);
  cv::initUndistortRectifyMap(K_r,D_r,R_r,P_r.rowRange(0,3).colRange(0,3),cv::Size(cols_r,rows_r),CV_32F,igb.M1r,igb.M2r);

  ros::NodeHandle nh;

  //Subscribe to camera
  message_filters::Subscriber<sensor_msgs::Image> left_sub(nh, "/camera/left/image_raw", 1);
  message_filters::Subscriber<sensor_msgs::Image> right_sub(nh, "/camera/right/image_raw", 1);
  typedef message_filters::sync_policies::ApproximateTime<sensor_msgs::Image, sensor_msgs::Image> sync_pol1;
  message_filters::Synchronizer<sync_pol1> sync1(sync_pol1(1), left_sub, right_sub);
  sync1.registerCallback(boost::bind(&MatchGrabber::Callback, &igb, _1, _2));

  //Subscribe to Ranging sensor and RTK
  ros::Subscriber range_sub = nh.subscribe("/ranger_finder/data", 1,&MatchGrabber::Range_Callback,&igb);
  ros::Subscriber groundtruth_sub = nh.subscribe("/rtk_groundtruth", 1,&MatchGrabber::GroundTruth_Callback,&igb);

  //Publish & Subscribe the rover status

  igb.rover_status_pub =  nh.advertise<filter_synchronizer1::slamMsg>("/rover_status", 1);

  //ros::Rate loop_rate(100);
  ros::spin();
  rangelog.close();
  timestamplog.close();
  groundtruthlog.close();
  hit_flag = false;

  return 0;
}
