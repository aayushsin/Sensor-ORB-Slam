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
#include <ros/publisher.h>
#include <message_filters/synchronizer.h>
#include <message_filters/sync_policies/approximate_time.h>
#include <sensor_msgs/Image.h>
#include <snowmower_msgs/DecaWaveMsg.h>
#include <anavs_rtk_dlr/odometry.h>
#include <ros/callback_queue.h>
#include <boost/bind.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <ros/package.h>

using namespace std;
using namespace message_filters;
static const std::string OPENCV_WINDOW1 = "Left Image window";
string path = ros::package::getPath("filter_synchronizer1");
string src_path = path.substr(0,path.find_last_of("/\\"));
string Image_path1 = src_path + "/left_image_data/";
string Image_path2 = "/home/aayushsingla/catkin_ws/src/right_image_data/";
string cali_filename = "/home/aayushsingla/catkin_ws/src/filter_synchronizer/src/bumblebee2.yaml";
string range_file = "/home/aayushsingla/catkin_ws/src/distance_data/range.txt";
string timestamp_file = "/home/aayushsingla/catkin_ws/src/time_stamp/time_stamp.txt";
string groundtruth_file = "/home/aayushsingla/catkin_ws/src/ground_truth/ground_truth.txt";

ros::CallbackQueue my_callback_queue;
ofstream rangelog;
ofstream timestamplog;
ofstream groundtruthlog;

std_msgs::Header last_img_header;
//ros::Publisher slam_pub;

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
/*

class MatchGrabber{
public:
  MatchGrabber(){}
  void Range_Callback(const snowmower_msgs::DecaWaveMsgConstPtr& message, ros::Publisher& slam_pub);
    float stored_range = 0.0;
    std::vector<double> matrix;
};


void MatchGrabber::Range_Callback(const snowmower_msgs::DecaWaveMsgConstPtr& message, ros::Publisher& slam_pub){
  hit_flag = true;
  stored_range = message->dist;
   filter_synchronizer1::slamMsg output;
  output.range = 10;
  range_last_timestamp = message->header.stamp.sec + message->header.stamp.nsec/1e9;
  //slam_pub.publish(output);

}



int main(int argc, char** argv)
{
  rangelog.open (range_file,ios::out | ios::trunc);  //  ios::app,   ios::ate ,other modes

  ros::init(argc, argv, "stereo1");
  ros::start();

  MatchGrabber igb;


  ros::NodeHandle nh;

  ros::Publisher slam_pub = nh.advertise<filter_synchronizer1::slamMsg>("stereoslam_bag", 1000);
  ros::Subscriber range_sub = nh.subscribe("/ranger_finder/data", 1,boost::bind(&MatchGrabber::Range_Callback,&igb,_1,slam_pub));

  ros::Rate loop_rate(100);
  ros::spin();
  rangelog.close();
  hit_flag = false;

  return 0;
}


class SubscribeAndPublish
{
public:
  SubscribeAndPublish()
  {
     MatchGrabber igb;


     ros::NodeHandle nh;

     ros::Publisher slam_pub = nh.advertise<filter_synchronizer1::slamMsg>("stereoslam_bag", 1000);
     ros::Subscriber range_sub = nh.subscribe("/ranger_finder/data", 1,&MatchGrabber::Range_Callback,&igb);
    //Topic you want to publish
    }

  void callback(const SUBSCRIBED_MESSAGE_TYPE& input)
  {
    PUBLISHED_MESSAGE_TYPE output;
    //.... do something with the input and generate the output...
    pub_.publish(output);
  }

private:
  ros::NodeHandle n_;
  ros::Publisher pub_;
  ros::Subscriber sub_;

};//End of class SubscribeAndPublish
*/

int main(int argc, char **argv)
{
rangelog.open (range_file,ios::out | ios::trunc);  //  ios::app,   ios::ate ,other modes
  //Initiate ROS
  ros::init(argc, argv, "subscribe_and_publish");

  //Create an object of class SubscribeAndPublish that will take care of everything
  //SubscribeAndPublish SAPObject;
  //std::string path = ros::package::getPath("filter_synchronizer1");
  cout << Image_path1<<endl;
  //int x = path.find_last_of("/\\");
  //cout <<path.substr (0,x) <<endl;

  //using ros::package::V_string;
  //V_string packages;
  //ros::package::getAll(packages);

  ros::spin();
  ros::Rate loop_rate(100);
  rangelog.close();
  hit_flag = false;

  return 0;
}
