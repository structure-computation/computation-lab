# encoding: utf-8


# Cela ne doit plus être necessaire sous devise. 

# class UserObserver < ActiveRecord::Observer
#   def after_create(user)  
#     # Correction du bug (frequent mais non systematique) de restfull auth. Le mauvais code d'activation etait envoye.
#     #user.logger.debug "observer 1"
#     user.reload
#     UserMailer.deliver_signup_notification(user)
#   end
# 
#   def after_save(user)
#     # Correction du bug (frequent mais non systematique) de restfull auth. Le mauvais code d'activation etait envoye.
#     user.reload  
#     UserMailer.deliver_activation(user) if user.recently_activated?
#   end
# end
