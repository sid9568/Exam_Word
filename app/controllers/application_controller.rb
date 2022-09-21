class ApplicationController < ActionController::Base
	include ApplicationHelper
 
  include ResponseJson

  def sendResponse code,entity,resultjson
    respond_to do |format|
        format.json { render :json => msgJson(code,entity).merge(resultjson) }         
    end 
  end
  
  def checkSessionToken
    sessionToken = request.headers['sessionToken']  
      if sessionToken.present?
        @currentSession = Session.where(session_token: sessionToken).first
        begin
            @user = @currentSession.user
            # @currentSessionRole = @user.role
      rescue
            render :json => {:code=>345, :message => "InvalidSessionToken"}
        end
      else
        render :json => {:code=>345, :message => "InvalidSessionToken"}
      end
  end

 def require_admin_logged_in 
    if request.format == "text/html" 
      unless admin_log_in?
        flash[:error]="You need to login first"
        redirect_to admin_login_path
      end
    end
  end

  def find_userAuthData(user,email)
    user.auths.find_by_email(email)
  end
  
  def admin_log_in?
    @admin ||= SuperAdmin.find(session[:admin_user_id]) if (session[:admin_user_id])
  end

end

end
