# encoding: utf-8

class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://beta.computation-lab.com/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://beta.computation-lab.com/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "noreply@structure-computation.com"
      @subject     = "computation-lab "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
