; Auto-generated. Do not edit!


(cl:in-package sensor_synchronizer-msg)


;//! \htmlinclude SyncDataMsg.msg.html

(cl:defclass <SyncDataMsg> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (image_left
    :reader image_left
    :initarg :image_left
    :type sensor_msgs-msg:Image
    :initform (cl:make-instance 'sensor_msgs-msg:Image))
   (image_right
    :reader image_right
    :initarg :image_right
    :type sensor_msgs-msg:Image
    :initform (cl:make-instance 'sensor_msgs-msg:Image))
   (range_distance
    :reader range_distance
    :initarg :range_distance
    :type cl:float
    :initform 0.0)
   (rtk_matrix_rotm
    :reader rtk_matrix_rotm
    :initarg :rtk_matrix_rotm
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (rtk_matrix_euler
    :reader rtk_matrix_euler
    :initarg :rtk_matrix_euler
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (rtk_latitude
    :reader rtk_latitude
    :initarg :rtk_latitude
    :type cl:float
    :initform 0.0)
   (rtk_longitude
    :reader rtk_longitude
    :initarg :rtk_longitude
    :type cl:float
    :initform 0.0))
)

(cl:defclass SyncDataMsg (<SyncDataMsg>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SyncDataMsg>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SyncDataMsg)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name sensor_synchronizer-msg:<SyncDataMsg> is deprecated: use sensor_synchronizer-msg:SyncDataMsg instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:header-val is deprecated.  Use sensor_synchronizer-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'image_left-val :lambda-list '(m))
(cl:defmethod image_left-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:image_left-val is deprecated.  Use sensor_synchronizer-msg:image_left instead.")
  (image_left m))

(cl:ensure-generic-function 'image_right-val :lambda-list '(m))
(cl:defmethod image_right-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:image_right-val is deprecated.  Use sensor_synchronizer-msg:image_right instead.")
  (image_right m))

(cl:ensure-generic-function 'range_distance-val :lambda-list '(m))
(cl:defmethod range_distance-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:range_distance-val is deprecated.  Use sensor_synchronizer-msg:range_distance instead.")
  (range_distance m))

(cl:ensure-generic-function 'rtk_matrix_rotm-val :lambda-list '(m))
(cl:defmethod rtk_matrix_rotm-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:rtk_matrix_rotm-val is deprecated.  Use sensor_synchronizer-msg:rtk_matrix_rotm instead.")
  (rtk_matrix_rotm m))

(cl:ensure-generic-function 'rtk_matrix_euler-val :lambda-list '(m))
(cl:defmethod rtk_matrix_euler-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:rtk_matrix_euler-val is deprecated.  Use sensor_synchronizer-msg:rtk_matrix_euler instead.")
  (rtk_matrix_euler m))

(cl:ensure-generic-function 'rtk_latitude-val :lambda-list '(m))
(cl:defmethod rtk_latitude-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:rtk_latitude-val is deprecated.  Use sensor_synchronizer-msg:rtk_latitude instead.")
  (rtk_latitude m))

(cl:ensure-generic-function 'rtk_longitude-val :lambda-list '(m))
(cl:defmethod rtk_longitude-val ((m <SyncDataMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader sensor_synchronizer-msg:rtk_longitude-val is deprecated.  Use sensor_synchronizer-msg:rtk_longitude instead.")
  (rtk_longitude m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SyncDataMsg>) ostream)
  "Serializes a message object of type '<SyncDataMsg>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'image_left) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'image_right) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'range_distance))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'rtk_matrix_rotm))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'rtk_matrix_rotm))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'rtk_matrix_euler))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'rtk_matrix_euler))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'rtk_latitude))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'rtk_longitude))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SyncDataMsg>) istream)
  "Deserializes a message object of type '<SyncDataMsg>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'image_left) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'image_right) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'range_distance) (roslisp-utils:decode-double-float-bits bits)))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'rtk_matrix_rotm) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'rtk_matrix_rotm)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits))))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'rtk_matrix_euler) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'rtk_matrix_euler)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits))))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'rtk_latitude) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'rtk_longitude) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SyncDataMsg>)))
  "Returns string type for a message object of type '<SyncDataMsg>"
  "sensor_synchronizer/SyncDataMsg")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SyncDataMsg)))
  "Returns string type for a message object of type 'SyncDataMsg"
  "sensor_synchronizer/SyncDataMsg")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SyncDataMsg>)))
  "Returns md5sum for a message object of type '<SyncDataMsg>"
  "bb36a0519783c0150aa9338d8c91d61c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SyncDataMsg)))
  "Returns md5sum for a message object of type 'SyncDataMsg"
  "bb36a0519783c0150aa9338d8c91d61c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SyncDataMsg>)))
  "Returns full string definition for message of type '<SyncDataMsg>"
  (cl:format cl:nil "Header header~%sensor_msgs/Image image_left~%sensor_msgs/Image image_right~%float64 range_distance~%float64[] rtk_matrix_rotm~%float64[] rtk_matrix_euler~%float64 rtk_latitude~%float64 rtk_longitude~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: sensor_msgs/Image~%# This message contains an uncompressed image~%# (0, 0) is at top-left corner of image~%#~%~%Header header        # Header timestamp should be acquisition time of image~%                     # Header frame_id should be optical frame of camera~%                     # origin of frame should be optical center of cameara~%                     # +x should point to the right in the image~%                     # +y should point down in the image~%                     # +z should point into to plane of the image~%                     # If the frame_id here and the frame_id of the CameraInfo~%                     # message associated with the image conflict~%                     # the behavior is undefined~%~%uint32 height         # image height, that is, number of rows~%uint32 width          # image width, that is, number of columns~%~%# The legal values for encoding are in file src/image_encodings.cpp~%# If you want to standardize a new string format, join~%# ros-users@lists.sourceforge.net and send an email proposing a new encoding.~%~%string encoding       # Encoding of pixels -- channel meaning, ordering, size~%                      # taken from the list of strings in include/sensor_msgs/image_encodings.h~%~%uint8 is_bigendian    # is this data bigendian?~%uint32 step           # Full row length in bytes~%uint8[] data          # actual matrix data, size is (step * rows)~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SyncDataMsg)))
  "Returns full string definition for message of type 'SyncDataMsg"
  (cl:format cl:nil "Header header~%sensor_msgs/Image image_left~%sensor_msgs/Image image_right~%float64 range_distance~%float64[] rtk_matrix_rotm~%float64[] rtk_matrix_euler~%float64 rtk_latitude~%float64 rtk_longitude~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: sensor_msgs/Image~%# This message contains an uncompressed image~%# (0, 0) is at top-left corner of image~%#~%~%Header header        # Header timestamp should be acquisition time of image~%                     # Header frame_id should be optical frame of camera~%                     # origin of frame should be optical center of cameara~%                     # +x should point to the right in the image~%                     # +y should point down in the image~%                     # +z should point into to plane of the image~%                     # If the frame_id here and the frame_id of the CameraInfo~%                     # message associated with the image conflict~%                     # the behavior is undefined~%~%uint32 height         # image height, that is, number of rows~%uint32 width          # image width, that is, number of columns~%~%# The legal values for encoding are in file src/image_encodings.cpp~%# If you want to standardize a new string format, join~%# ros-users@lists.sourceforge.net and send an email proposing a new encoding.~%~%string encoding       # Encoding of pixels -- channel meaning, ordering, size~%                      # taken from the list of strings in include/sensor_msgs/image_encodings.h~%~%uint8 is_bigendian    # is this data bigendian?~%uint32 step           # Full row length in bytes~%uint8[] data          # actual matrix data, size is (step * rows)~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SyncDataMsg>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'image_left))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'image_right))
     8
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'rtk_matrix_rotm) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'rtk_matrix_euler) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SyncDataMsg>))
  "Converts a ROS message object to a list"
  (cl:list 'SyncDataMsg
    (cl:cons ':header (header msg))
    (cl:cons ':image_left (image_left msg))
    (cl:cons ':image_right (image_right msg))
    (cl:cons ':range_distance (range_distance msg))
    (cl:cons ':rtk_matrix_rotm (rtk_matrix_rotm msg))
    (cl:cons ':rtk_matrix_euler (rtk_matrix_euler msg))
    (cl:cons ':rtk_latitude (rtk_latitude msg))
    (cl:cons ':rtk_longitude (rtk_longitude msg))
))
