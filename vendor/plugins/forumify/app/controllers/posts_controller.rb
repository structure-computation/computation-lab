class PostsController < InheritedResources::Base       
  before_filter :authenticate_user!, :only => [:edit, :update, :destroy, :create, :new]    

  nested_belongs_to :forum, :topic                 
  uses_tiny_mce :options => { :plugins => ["spellchecker"]}, 
                :raw_option => '',
                :only => ['edit_page']
   
  def new     
    @forum = Forum.find(params[:forum_id])
    @topic = Topic.find(params[:topic_id])
    new!    
  end
                                          
  def create
    @post = Post.new(params[:post])
    @post.user = current_user  
    
    create!
  end           

    
  def show
  @post = Post.find_by_id(params[:id])     
  end
  
  def index
    @forum = Forum.find(params[:forum_id])
    @topic = Topic.find(params[:topic_id])
    index!
  end                         
end
