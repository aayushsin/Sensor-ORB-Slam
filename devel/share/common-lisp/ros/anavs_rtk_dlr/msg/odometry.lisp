; Auto-generated. Do not edit!


(cl:in-package anavs_rtk_dlr-msg)


;//! \htmlinclude odometry.msg.html

(cl:defclass <odometry> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (rtk_matrix_euler
    :reader rtk_matrix_euler
    :initarg :rtk_matrix_euler
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (rtk_matrix_rotm
    :reader rtk_matrix_rotm
    :initarg :rtk_matrix_rotm
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

(cl:defclass odometry (<odometry>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <odometry>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'odometry)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name anavs_rtk_dlr-msg:<odometry> is deprecated: use anavs_rtk_dlr-msg:odometry instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <odometry>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader anavs_rtk_dlr-msg:header-val is deprecated.  Use anavs_rtk_dlr-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'rtk_matrix_euler-val :lambda-list '(m))
(cl:defmethod rtk_matrix_euler-val ((m <odometry>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader anavs_rtk_dlr-msg:rtk_matrix_euler-val is deprecated.  Use anavs_rtk_dlr-msg:rtk_matrix_euler instead.")
  (rtk_matrix_euler m))

(cl:ensure-generic-function 'rtk_matrix_rotm-val :lambda-list '(m))
(cl:defmethod rtk_matrix_rotm-val ((m <odometry>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader anavs_rtk_dlr-msg:rtk_matrix_rotm-val is deprecated.  Use anavs_rtk_dlr-msg:rtk_matrix_rotm instead.")
  (rtk_matrix_rotm m))

(cl:ensure-generic-function 'rtk_latitude-val :lambda-list '(m))
(cl:defmethod rtk_latitude-val ((m <odometry>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader anavs_rtk_dlr-msg:rtk_latitude-val is deprecated.  Use anavs_rtk_dlr-msg:rtk_latitude instead.")
  (rtk_latitude m))

(cl:ensure-generic-function 'rtk_longitude-val :lambda-list '(m))
(cl:defmethod rtk_longitude-val ((m <odometry>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader anavs_rtk_dlr-msg:rtk_longitude-val is deprecated.  Use anavs_rtk_dlr-msg:rtk_longitude instead.")
  (rtk_longitude m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <odometry>) ostream)
  "Serializes a message object of type '<odometry>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
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
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <odometry>) istream)
  "Deserializes a message object of type '<odometry>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<odometry>)))
  "Returns string type for a message object of type '<odometry>"
  "anavs_rtk_dlr/odometry")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'odometry)))
  "Returns string type for a message object of type 'odometry"
  "anavs_rtk_dlr/odometry")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<odometry>)))
  "Returns md5sum for a message object of type '<odometry>"
  "b2f0231f8165be3ce395cb35e551e3a0")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'odometry)))
  "Returns md5sum for a message object of type 'odometry"
  "b2f0231f8165be3ce395cb35e551e3a0")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<odometry>)))
  "Returns full string definition for message of type '<odometry>"
  (cl:format cl:nil "Header header~%float64[] rtk_matrix_euler~%float64[] rtk_matrix_rotm~%float64 rtk_latitude~%float64 rtk_longitude~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'odometry)))
  "Returns full string definition for message of type 'odometry"
  (cl:format cl:nil "Header header~%float64[] rtk_matrix_euler~%float64[] rtk_matrix_rotm~%float64 rtk_latitude~%float64 rtk_longitude~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <odometry>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'rtk_matrix_euler) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'rtk_matrix_rotm) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <odometry>))
  "Converts a ROS message object to a list"
  (cl:list 'odometry
    (cl:cons ':header (header msg))
    (cl:cons ':rtk_matrix_euler (rtk_matrix_euler msg))
    (cl:cons ':rtk_matrix_rotm (rtk_matrix_rotm msg))
    (cl:cons ':rtk_latitude (rtk_latitude msg))
    (cl:cons ':rtk_longitude (rtk_longitude msg))
))
