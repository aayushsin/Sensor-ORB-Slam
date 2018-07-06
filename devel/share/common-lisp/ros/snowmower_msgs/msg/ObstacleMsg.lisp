; Auto-generated. Do not edit!


(cl:in-package snowmower_msgs-msg)


;//! \htmlinclude ObstacleMsg.msg.html

(cl:defclass <ObstacleMsg> (roslisp-msg-protocol:ros-message)
  ((angle
    :reader angle
    :initarg :angle
    :type cl:float
    :initform 0.0)
   (distance
    :reader distance
    :initarg :distance
    :type cl:float
    :initform 0.0))
)

(cl:defclass ObstacleMsg (<ObstacleMsg>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ObstacleMsg>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ObstacleMsg)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name snowmower_msgs-msg:<ObstacleMsg> is deprecated: use snowmower_msgs-msg:ObstacleMsg instead.")))

(cl:ensure-generic-function 'angle-val :lambda-list '(m))
(cl:defmethod angle-val ((m <ObstacleMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader snowmower_msgs-msg:angle-val is deprecated.  Use snowmower_msgs-msg:angle instead.")
  (angle m))

(cl:ensure-generic-function 'distance-val :lambda-list '(m))
(cl:defmethod distance-val ((m <ObstacleMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader snowmower_msgs-msg:distance-val is deprecated.  Use snowmower_msgs-msg:distance instead.")
  (distance m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ObstacleMsg>) ostream)
  "Serializes a message object of type '<ObstacleMsg>"
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'angle))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'distance))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ObstacleMsg>) istream)
  "Deserializes a message object of type '<ObstacleMsg>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'angle) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'distance) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ObstacleMsg>)))
  "Returns string type for a message object of type '<ObstacleMsg>"
  "snowmower_msgs/ObstacleMsg")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ObstacleMsg)))
  "Returns string type for a message object of type 'ObstacleMsg"
  "snowmower_msgs/ObstacleMsg")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ObstacleMsg>)))
  "Returns md5sum for a message object of type '<ObstacleMsg>"
  "f5a2ee2aaf541b354d2c44aa9ea8522e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ObstacleMsg)))
  "Returns md5sum for a message object of type 'ObstacleMsg"
  "f5a2ee2aaf541b354d2c44aa9ea8522e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ObstacleMsg>)))
  "Returns full string definition for message of type '<ObstacleMsg>"
  (cl:format cl:nil "float64 angle~%float64 distance~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ObstacleMsg)))
  "Returns full string definition for message of type 'ObstacleMsg"
  (cl:format cl:nil "float64 angle~%float64 distance~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ObstacleMsg>))
  (cl:+ 0
     8
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ObstacleMsg>))
  "Converts a ROS message object to a list"
  (cl:list 'ObstacleMsg
    (cl:cons ':angle (angle msg))
    (cl:cons ':distance (distance msg))
))
