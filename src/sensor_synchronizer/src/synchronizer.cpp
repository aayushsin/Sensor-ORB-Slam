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
#include <sensor_synchronizer/SyncDataMsg.h>
#include <ros/package.h>
#include <boost/filesystem.hpp>
#include <dlr_ranging/ranging_msg.h>

using namespace std;
using namespace message_filters;
static const std::string OPENCV_WINDOW1 = "Left Image window";
string path = ros::package::getPath("sensor_synchronizer");
string wk_path = path.substr(0,path.find("/src/"));
string Image_path1;
string Image_path2;
string cali_filename = path + "/src/EuRoC.yaml";
string range_file;
string timestamp_file;
string groundtruth_file;
string groundtrutheuler_file;
string groundtruthcoordinates_file;

ros::CallbackQueue my_callback_queue;
ofstream rangelog;
ofstream timestamplog;
ofstream groundtruthlog;
ofstream groundtrutheulerlog;
ofstream groundtruthcoordinateslog;
std_msgs::Header last_img_header;


//Set Defaults
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
double dist_usrp_dlr_timestamp = 0.0;
bool storage_mode = true;               //turn on storage mode
bool use_time_difference = true;        //use time as storing parameter
bool hit_flag = false;                  //a match hit when dataset from three topics available
int recording_image_frame = 2;          //recording rate for dataset
double recording_image_second = 0.040; // in seconds
bool saved_last= false;
bool use_decawave_ranging = true;
sensor_msgs::Image msgLastLeft;
sensor_msgs::Image msgLastRight;


class MatchGrabber{
public:
  MatchGrabber(){}

  void Callback(const sensor_msgs::ImageConstPtr &msgLeft, const sensor_msgs::ImageConstPtr &msgRight);
  void Range_Callback(const snowmower_msgs::DecaWaveMsgConstPtr& message);
  void GroundTruth_Callback(const anavs_rtk_dlr::odometryConstPtr& message);
  void Range_USRP_DLR_Callback(const dlr_ranging::ranging_msgPtr& message);
  cv::Mat M1l,M2l,M1r,M2r;
  float range_measurement = 0.0;
  std::vector<double> rtk_matrix_rotm;
  float rtk_latitude;
  float rtk_longitude;
  std::vector<double> rtk_matrix_euler;
  ros::Publisher rover_sync_data_pub;
  ros::Publisher rover_sync_record_pub;
  sensor_synchronizer::SyncDataMsg rover_sync_data;
  sensor_synchronizer::SyncDataMsg rover_sync_record;
  float dist_usrp_dlr = 0.0;
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

//Display the images
//   cv::imshow("Left Image", imLeft);
//   cv::imshow("Right Image",imRight);
//   cv::waitKey(2);


    //Override the UWB ranging with dlr ranging
   if (!use_decawave_ranging){
        range_measurement = dist_usrp_dlr;
        range_last_timestamp=dist_usrp_dlr_timestamp;
   }

    //If no ranging measurement found
  if (range_measurement ==  0) {
    cout << "Ranging measurement [m] = -1" << endl;
    }
  else {
    cout << "Ranging measurement [m] = " << range_measurement << endl;
    }

  static int image_counter1 = -1; //Left Image Counter
  static int image_counter2 = -1; //Right Image Counter

  Left_img_sec = msgLeft->header.stamp.sec;
  Left_img_nsec = msgLeft->header.stamp.nsec;
  Right_img_sec = msgRight->header.stamp.sec;
  Right_img_nsec = msgRight->header.stamp.nsec;
  Left_mean_timestamp =  (Left_last_timestamp + Left_img_sec + Left_img_nsec/1e9)/2.0; //mean time stamp used by the range finder synchronization

  // no sychronized topics
  if (!hit_flag){
        //Add the time, range, rtk matrices, images to sync data topic
        rover_sync_data.range_distance = -1;
        rover_sync_data.header.stamp = msgLeft->header.stamp;
        rover_sync_data.image_left = *msgLeft;
        rover_sync_data.image_right = *msgRight;
        rover_sync_data.rtk_matrix_rotm = rtk_matrix_rotm;
        rover_sync_data.rtk_matrix_euler = rtk_matrix_euler;
        rover_sync_data.rtk_latitude = rtk_latitude;
        rover_sync_data.rtk_longitude = rtk_longitude;
        rover_sync_data.rtk_current_measurement = false;
        if (abs(rover_sync_data.header.stamp.sec + rover_sync_data.header.stamp.nsec/1e9 - rtk_timestamp) < 0.02 )
            rover_sync_data.rtk_current_measurement = true;
//	    rover_sync_data.dist_usrp_dlr = dist_usrp_dlr;

        //use time as storage parameter
         if (use_time_difference){
            if(Left_img_sec + Left_img_nsec/1e9-Left_last_timestamp > recording_image_second ){
                //Add the time, range, rtk matrices, images to sync record topic
                rover_sync_record.image_left = *msgLeft;
                rover_sync_record.range_distance = -1;
                rover_sync_record.header.stamp = msgLeft->header.stamp;
                rover_sync_record.rtk_matrix_rotm = rtk_matrix_rotm;
                rover_sync_record.rtk_matrix_euler = rtk_matrix_euler;
                rover_sync_record.rtk_latitude = rtk_latitude;
                rover_sync_record.rtk_longitude = rtk_longitude;
                rover_sync_record.rtk_current_measurement = false;
                if (abs(rover_sync_record.header.stamp.sec + rover_sync_record.header.stamp.nsec/1e9 - rtk_timestamp) < 0.02 )
                    rover_sync_record.rtk_current_measurement = true;
                image_counter1++;
                saved_last = true;

                if (storage_mode){
                //Write timestamp and range file and ground_truth files
                    std::string savingName1 = Image_path1 + "Left_image" + std::to_string(image_counter1) + ".png";
                    cv::imwrite(savingName1, imLeft);
                    for (std::vector<double>::const_iterator i = rtk_matrix_rotm.begin(); i != rtk_matrix_rotm.end(); ++i)
                        groundtruthlog << *i << " ";
          //          groundtruthlog << rover_sync_record.rtk_current_measurement << endl;
                    //groundtruthlog <<""<<endl;
                    for (std::vector<double>::const_iterator i = rtk_matrix_euler.begin(); i != rtk_matrix_euler.end(); ++i)
                        groundtrutheulerlog << *i << " ";
         //           groundtrutheulerlog << rover_sync_record.rtk_current_measurement << endl;
                    //groundtrutheulerlog <<""<<endl;
                    groundtruthcoordinateslog << rtk_latitude << "\t" << rtk_longitude << endl;
                    timestamplog << msgLeft->header.stamp.sec << "." << msgLeft->header.stamp.nsec << endl;
                    rangelog << std::to_string(-1)<<endl;
                }
            }

            if(Right_img_sec + Right_img_nsec/1e9-Right_last_timestamp > recording_image_second){
                image_counter2++;
                if (storage_mode){
                    std::string savingName2 = Image_path2 + "Right_image" + std::to_string(image_counter2) + ".png";
                    cv::imwrite(savingName2, imRight);
                }
                rover_sync_record.image_right = *msgRight;
            }
         }
         else{ //use frames as storage parameter
                if(image_counter1%recording_image_frame ==0){
                    image_counter1++;
                    //Add the time, range, rtk matrices, images to sync record topic
                    rover_sync_record.image_left = *msgLeft;
                    rover_sync_record.range_distance = -1;
                    rover_sync_record.header.stamp = msgLeft->header.stamp;
                    rover_sync_record.rtk_matrix_rotm = rtk_matrix_rotm;
                    rover_sync_record.rtk_matrix_euler = rtk_matrix_euler;
                    rover_sync_record.rtk_latitude = rtk_latitude;
                    rover_sync_record.rtk_longitude = rtk_longitude;
                    saved_last = true;
                    rover_sync_record.rtk_current_measurement = false;
                    if (abs(rover_sync_record.header.stamp.sec + rover_sync_record.header.stamp.nsec/1e9 - rtk_timestamp) < 0.02 )
                        rover_sync_record.rtk_current_measurement = true;

                    if(storage_mode){
                        std::string savingName1 = Image_path1 + "Left_image" + std::to_string(image_counter1) + ".png";
                        cv::imwrite(savingName1, imLeft);
                        //Write timestamp and range file and ground_truth files
                        for (std::vector<double>::const_iterator i = rtk_matrix_rotm.begin(); i != rtk_matrix_rotm.end(); ++i)
                            groundtruthlog << *i << " ";
         //               groundtruthlog << rover_sync_data.rtk_current_measurement << endl;
                        //groundtruthlog <<""<<endl;
                        for (std::vector<double>::const_iterator i = rtk_matrix_euler.begin(); i != rtk_matrix_euler.end(); ++i)
                            groundtrutheulerlog << *i << " ";
          //              groundtrutheulerlog << rover_sync_data.rtk_current_measurement << endl;
                        //groundtrutheulerlog <<""<<endl;
                        groundtruthcoordinateslog << rtk_latitude << "\t" << rtk_longitude << endl;
                        timestamplog << msgLeft->header.stamp.sec << "." << msgLeft->header.stamp.nsec << endl;
                        rangelog << std::to_string(-1)<<endl;
                    }
                }
               if(image_counter2%recording_image_frame ==0){
                    image_counter2++;
                    if(storage_mode){
                        std::string savingName2 = Image_path2 + "Right_image" + std::to_string(image_counter2) + ".png";
                        cv::imwrite(savingName2, imRight);
                    }
                    rover_sync_record.image_right = *msgRight;
               }
          }
  }
    else { //got the ranging measurement and hit_flag=true
        if (range_last_timestamp < Left_mean_timestamp){
            //Add the time, range, rtk matrices to the publishers
            rover_sync_data.header.stamp = msgLeft->header.stamp;
            rover_sync_data.range_distance = range_measurement;
            rover_sync_data.rtk_matrix_rotm = rtk_matrix_rotm;
            rover_sync_data.rtk_matrix_euler = rtk_matrix_euler;
            rover_sync_data.rtk_latitude = rtk_latitude;
            rover_sync_data.rtk_longitude = rtk_longitude;
	      //rover_sync_data.dist_usrp_dlr = dist_usrp_dlr;

            rover_sync_record.range_distance = range_measurement;
            rover_sync_record.rtk_matrix_rotm = rtk_matrix_rotm;
            rover_sync_record.rtk_matrix_euler = rtk_matrix_euler;
            rover_sync_record.rtk_latitude = rtk_latitude;
            rover_sync_record.rtk_longitude = rtk_longitude;

            // Add the images to sync_data topic
            rover_sync_data.image_left = *msgLeft;
            rover_sync_data.image_right = *msgRight;


            image_counter1++;
            image_counter2++;

            //Add the images to sync_record topic
            if (saved_last){
                rover_sync_record.header.stamp = msgLeft->header.stamp;
                rover_sync_record.image_left = *msgLeft;
                rover_sync_record.image_right = *msgRight;
            }else{
                rover_sync_record.header.stamp = last_img_header.stamp;
                rover_sync_record.image_left = msgLastLeft;
                rover_sync_record.image_left = msgLastRight;
                }

            if(storage_mode){
            //Write timestamp and range file and ground_truth files
                timestamplog << last_img_header.stamp.sec << "." << last_img_header.stamp.nsec << endl;
                rangelog << range_measurement <<endl;
                for (std::vector<double>::const_iterator i = rtk_matrix_rotm.begin(); i != rtk_matrix_rotm.end(); ++i)
                    groundtruthlog << *i << " ";
                //groundtruthlog <<""<<endl;
            //    groundtruthlog << rover_sync_data.rtk_current_measurement << endl;
                for (std::vector<double>::const_iterator i = rtk_matrix_euler.begin(); i != rtk_matrix_euler.end(); ++i)
                    groundtrutheulerlog << *i << " ";
                //groundtrutheulerlog <<""<<endl;
             //   groundtrutheulerlog << rover_sync_data.rtk_current_measurement << endl;
                groundtruthcoordinateslog << rtk_latitude << "\t" << rtk_longitude << endl;

                std::string savingName1 = Image_path1 + "Left_image" + std::to_string(image_counter1) + ".png";
                cv::imwrite(savingName1, imLeft);
                std::string savingName2 = Image_path2 + "Right_image" + std::to_string(image_counter2) + ".png";
                cv::imwrite(savingName2, imRight);
            }
            saved_last =false;
          }
        else { //take the new image as ranging time is closer to new image
            //Add the time, range, rtk matrices to the publishers
            rover_sync_data.header.stamp = msgLeft->header.stamp;
            rover_sync_data.range_distance = range_measurement;
            rover_sync_data.rtk_matrix_rotm = rtk_matrix_rotm;
            rover_sync_data.rtk_matrix_euler = rtk_matrix_euler;
            rover_sync_data.rtk_latitude = rtk_latitude;
            rover_sync_data.rtk_longitude =rtk_longitude;
	        //rover_sync_data.dist_usrp_dlr = dist_usrp_dlr;
	    
            rover_sync_record.header.stamp = msgLeft->header.stamp;
            rover_sync_record.range_distance = range_measurement;
            rover_sync_record.rtk_matrix_rotm = rtk_matrix_rotm;
            rover_sync_record.rtk_matrix_euler = rtk_matrix_euler;
            rover_sync_record.rtk_latitude = rtk_latitude;
            rover_sync_record.rtk_longitude =rtk_longitude;

            // Add the images to sync_data topic
            rover_sync_data.image_left = *msgLeft;
            rover_sync_data.image_right = *msgRight;
            rover_sync_record.image_left = *msgLeft;
            rover_sync_record.image_right = *msgRight;
            image_counter1++;
            image_counter2++;

            if (storage_mode){
                //Write timestamp and range file and ground_truth files
                timestamplog << msgLeft->header.stamp.sec << "." << msgLeft->header.stamp.nsec << endl;
                rangelog << range_measurement <<endl;
                for (std::vector<double>::const_iterator i = rtk_matrix_rotm.begin(); i != rtk_matrix_rotm.end(); ++i)
                    groundtruthlog << *i << " ";
              //  groundtruthlog <<""<<endl;
                for (std::vector<double>::const_iterator i = rtk_matrix_euler.begin(); i != rtk_matrix_euler.end(); ++i)
                    groundtrutheulerlog << *i << " ";
             //   groundtrutheulerlog <<""<<endl;
                groundtruthcoordinateslog << rtk_latitude << "\t" << rtk_longitude << endl;
                std::string savingName1 = Image_path1 + "Left_image" + std::to_string(image_counter1) + ".png";
                cv::imwrite(savingName1, imLeft);
                std::string savingName2 = Image_path2 + "Right_image" + std::to_string(image_counter2) + ".png";
                cv::imwrite(savingName2, imRight);
            }
            saved_last = false;
        }
        rover_sync_data.rtk_current_measurement = false;
        if (abs(rover_sync_data.header.stamp.sec + rover_sync_data.header.stamp.nsec/1e9 - rtk_timestamp) < 0.02 )
            rover_sync_data.rtk_current_measurement = true;
        rover_sync_record.rtk_current_measurement = false;
        if (abs(rover_sync_record.header.stamp.sec + rover_sync_record.header.stamp.nsec/1e9 - rtk_timestamp) < 0.02 )
            rover_sync_record.rtk_current_measurement = true;
        if (storage_mode){
//            groundtruthlog << rover_sync_data.rtk_current_measurement << endl;
//            groundtrutheulerlog << rover_sync_data.rtk_current_measurement << endl;
        }
        hit_flag = false;
      }
    last_img_header = msgLeft->header;
    Left_last_timestamp = Left_img_sec + Left_img_nsec/1e9;
    Right_last_timestamp = Right_img_sec + Right_img_nsec/1e9;
    rover_sync_data_pub.publish(rover_sync_data);
    rover_sync_record_pub.publish(rover_sync_record);
    msgLastLeft = *msgLeft;
    msgLastRight = *msgRight;
}

void MatchGrabber::Range_Callback(const snowmower_msgs::DecaWaveMsgConstPtr& message){
  hit_flag = true;
  range_measurement = message->dist;
  range_last_timestamp = message->header.stamp.sec + message->header.stamp.nsec/1e9;
}

void MatchGrabber::Range_USRP_DLR_Callback(const dlr_ranging::ranging_msgPtr& message){
  hit_flag = true;
  dist_usrp_dlr = message->ranging;
  dist_usrp_dlr_timestamp = message->header.stamp.sec + message->header.stamp.nsec/1e9;
//  range_measurement = message->ranging;
//  range_last_timestamp = message->header.stamp.sec + message->header.stamp.nsec/1e9;
}

void MatchGrabber::GroundTruth_Callback(const anavs_rtk_dlr::odometryConstPtr& message){
    rtk_matrix_rotm = message ->rtk_matrix_rotm;
    rtk_matrix_euler = message ->rtk_matrix_euler;
    rtk_timestamp = message->header.stamp.sec + message->header.stamp.nsec/1e9;
    rtk_latitude = message -> rtk_latitude;
    rtk_longitude = message -> rtk_longitude;
}


int main(int argc, char** argv)
{
  ros::init(argc, argv, "stereo_ranging_rtk");
  ros::start();
  ros::Time current = ros::Time::now();
  boost::posix_time::ptime current_posix_time = current.toBoost();
  std::string current_iso_time = boost::posix_time::to_iso_extended_string(current_posix_time).substr(0,19); // get current UTC time
  replace(current_iso_time.begin(), current_iso_time.end(), 'T', '_');
  //replace(current_iso_time.begin(), current_iso_time.end(), ':', '');
  current_iso_time.erase(std::remove(current_iso_time.begin(), current_iso_time.end(), ':'), current_iso_time.end());
  std::string foldername = "storage_" + current_iso_time;
  std::string folderpath = wk_path + "/storage/" + foldername;
  
  Image_path1 = folderpath + "/left_image_data/";
  Image_path2 = folderpath + "/right_image_data/";
  range_file = folderpath + "/distance_data/range.txt";
  timestamp_file = folderpath + "/time_stamp/time_stamp.txt";
  groundtruth_file = folderpath + "/ground_truth/ground_truth.txt";
  groundtrutheuler_file = folderpath + "/ground_truth/ground_truth_euler.txt";
  groundtruthcoordinates_file = folderpath + "/ground_truth/ground_truth_coordinates.txt";

  
  MatchGrabber igb;

  cv::FileStorage fsSettings(cali_filename, cv::FileStorage::READ);

  if(!fsSettings.isOpened())
  {
    cerr << "ERROR: Wrong path to settings" << endl;
    return -1;
  }

  cv::Mat K_l, K_r, P_l, P_r, R_l, R_r, D_l, D_r,P_l2,P_l3,R1,R2,P1,P2,Q,P_r2,T_lw,T_rw;

  fsSettings["LEFT.K"] >> K_l;
  fsSettings["RIGHT.K"] >> K_r;

  fsSettings["LEFT.P"] >> P_l;
  fsSettings["RIGHT.P"] >> P_r;

  fsSettings["LEFT.T_lw"] >> T_lw;
  fsSettings["RIGHT.T_rw"] >> T_rw;

  fsSettings["LEFT.R"] >> R_l;
  fsSettings["RIGHT.R"] >> R_r;

  fsSettings["LEFT.D"] >> D_l;
  fsSettings["RIGHT.D"] >> D_r;
  float b_f = fsSettings["Camera.bf"];

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
  ros::param::get("~recording_image_frame", recording_image_frame);
  ros::param::get("~recording_image_second", recording_image_second);
  ros::param::get("~use_recording_image_second", use_time_difference);
  ros::param::get("~storage_mode", storage_mode);
  ros::param::get("~use_decawave_ranging", use_decawave_ranging);
  ros::param::set("folderpath", folderpath+"/subset/");

//Dump the parameters
//  std::string command = " echo 'ROS Params dumped' ; rosparam dump " + path +"/temporary.yaml";
//  system(command.c_str());

//Create folders and files
if (storage_mode){
  boost::filesystem::create_directories(folderpath);
  boost::filesystem::create_directories(folderpath +"/distance_data");
  boost::filesystem::create_directories(folderpath + "/ground_truth");
  boost::filesystem::create_directories(folderpath+ "/left_image_data");
  boost::filesystem::create_directories(folderpath+"/right_image_data");
  boost::filesystem::create_directories(folderpath+"/time_stamp");
  rangelog.open (range_file,ios::out | ios::trunc);  //  ios::app,   ios::ate ,other modes
  timestamplog.open (timestamp_file,ios::out | ios::trunc);
  groundtruthlog.open (groundtruth_file,ios::out | ios::trunc);
  groundtrutheulerlog.open (groundtrutheuler_file,ios::out | ios::trunc);
  groundtruthcoordinateslog.open (groundtruthcoordinates_file,ios::out | ios::trunc);
  groundtruthcoordinateslog << "Latitude   Longitude" << endl;
}
  //Subscribe the stereo images and sync
  message_filters::Subscriber<sensor_msgs::Image> left_sub(nh, "/camera/left/image_raw", 1);
  message_filters::Subscriber<sensor_msgs::Image> right_sub(nh, "/camera/right/image_raw", 1);
  typedef message_filters::sync_policies::ApproximateTime<sensor_msgs::Image, sensor_msgs::Image> sync_pol1;
  message_filters::Synchronizer<sync_pol1> sync1(sync_pol1(1), left_sub, right_sub);
  sync1.registerCallback(boost::bind(&MatchGrabber::Callback, &igb, _1, _2));

  //Subscribe the uwb ranging or the DLR's usrp-based ranging
  ros::Subscriber range_usrp_dlr_sub = nh.subscribe("/dlr_kn/dist_estimates_cut", 1, &MatchGrabber::Range_USRP_DLR_Callback,&igb);
  ros::Subscriber range_sub = nh.subscribe("/ranger_finder/data", 1,&MatchGrabber::Range_Callback,&igb);
/*  if (use_decawave_ranging){ //Subscribe the uwb ranging
    ros::Subscriber range_sub = nh.subscribe("/ranger_finder/data", 1,&MatchGrabber::Range_Callback,&igb);
  }else{ //Subscribe the DLR's usrp-based ranging
    ros::Subscriber range_usrp_dlr_sub = nh.subscribe("/dlr_kn/dist_estimates_cut", 1, &MatchGrabber::Range_USRP_DLR_Callback,&igb);
  }*/
  
  //Subscribe the rtk
  ros::Subscriber groundtruth_sub = nh.subscribe("/rtk_odometry", 1,&MatchGrabber::GroundTruth_Callback,&igb);
  
  //Publish the synchronized dataset
  igb.rover_sync_data_pub =  nh.advertise<sensor_synchronizer::SyncDataMsg>("/tum_nav/sync_data", 1);
  igb.rover_sync_record_pub =  nh.advertise<sensor_synchronizer::SyncDataMsg>("/tum_nav/sync_record", 1);

  //ros::Rate loop_rate(100);
  ros::spin();

if (storage_mode){
  rangelog.close();
  timestamplog.close();
  groundtruthlog.close();
  groundtrutheulerlog.close();
  groundtruthcoordinateslog.close();
}
  hit_flag = false;

  return 0;
}
