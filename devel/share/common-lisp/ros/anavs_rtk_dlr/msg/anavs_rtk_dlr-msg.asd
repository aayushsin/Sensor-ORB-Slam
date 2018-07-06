
(cl:in-package :asdf)

(defsystem "anavs_rtk_dlr-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "odometry" :depends-on ("_package_odometry"))
    (:file "_package_odometry" :depends-on ("_package"))
  ))