class TopicsController < InheritedResources::Base             
  belongs_to :forum 
  before_filter :authenticate_user!  
  
  def index  
    @forum = Forum.find(params[:forum_id])  
    @topics = @forum.topics  
  end  
  
  def new 
    @forum = Forum.find(params[:forum_id])      
    @topic = Topic.new   
  end  
  
end
