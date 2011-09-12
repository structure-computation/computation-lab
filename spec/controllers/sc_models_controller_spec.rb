require 'spec_helper'

# describe ScModelsController do 
#   # module MySpecHelper
#   # 
#   #   # get all actions for specified controller
#   #   def get_all_actions(cont)
#   #     c= Module.const_get(cont.to_s.pluralize.pluralize + "Controller")
#   #     c.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
#   #   end
#   # 
#   #   # test actions fail if not logged in
#   #   # opts[:exclude] contains an array of actions to skip
#   #   # opts[:include] contains an array of actions to add to the test in addition
#   #   # to any found by get_all_actions
#   #   def controller_actions_should_fail_if_not_logged_in(cont, opts={})
#   #     except= opts[:except] || []
#   #     actions_to_test= get_all_actions(cont).reject{ |a| except.include?(a) }
#   #     actions_to_test += opts[:include] if opts[:include]
#   #     actions_to_test.each do |a|
#   #       #puts "... #{a}"
#   #       get a
#   #       response.should_not be_success
#   #       response.should redirect_to('http://test.host/login')
#   #       flash[:warning].should == @login_warning
#   #     end
#   #   end                                             
#   #  
#   #  def controller_actions_should_fail_with_get(cont, except=[])
#   #    actions_to_test= get_all_actions(cont).reject{ |a| except.include?(a) }
#   #    actions_to_test.each do |a|
#   #      #puts "... #{a}"
#   #      get a
#   #      response.should redirect_to("http://test.host/#{cont.to_s.pluralize}")
#   #      flash[:error].should == 'Operation Failed'
#   #    end
#   #  end    
#   #  
#   #  it "actions should fail if not post or put" do
#   #    controller_actions_should_fail_with_get(:event, ['index', 'show', 'edit', 'new'])
#   #  end    
#   
#   # INDEX 
#   describe "index" do
#     it "renders the index template" do
#       get :index
#       response.should render_template("index")
#       response.body.should == ""
#     end
#     it "renders the sc_models/index template" do
#       get :index
#       response.should render_template("sc_models/index")
#       response.body.should == ""
#     end  
#   end 
#     
#   # UPDATE
#   describe "PUT sc_models/:id" do  
#     describe "with valid params" do
#       before(:each) do
#         @sc_models = mock_model(ScModels, :update_attributes => true)
#         ScModels.stub!(:find).with("1").and_return(@sc_models)
#       end
# 
#       it "should find sc_models and return object" do
#         ScModels.should_receive(:find).with("1").return(@sc_models)
#       end
# 
#       it "should update the sc_models object's attributes" do
#         @sc_models.should_receive(:update_attributes).and_return(true)
#       end
# 
#       it "should redirect to the sc_models's show page" do
#         response.should redirect_to(sc_models_url(@sc_models))
#       end
#     end 
# 
#     describe "with invalid params" do
#       before(:each) do
#         @sc_models = mock_model(sc_models, :update_attributes => false)
#         sc_models.stub!(:find).with("1").and_return(@sc_models)
#       end
# 
#       it "should find sc_models and return object" do
#         sc_models.should_receive(:find).with("1").return(@sc_models)
#       end
# 
#       it "should update the sc_models object's attributes" do
#         @sc_models.should_receive(:update_attributes).and_return(false)
#       end
# 
#       it "should render the edit form" do
#         response.should render_template('edit')
#       end
# 
#       it "should have a flash notice" do
#         flash[:notice].should_not be_blank
#       end  
#     end 
#     
#     # DELETE
#     describe "PUT sc_models/:id" do  
#       describe "with valid params" do
#         before(:each) do
#           @sc_models = mock_model(ScModels, :update_attributes => true)
#           ScModels.stub!(:delete).with("1").and_return(false)
#         end
# 
#         it "should find sc_models and return object" do
#           ScModels.should_receive(:find).with("1").return(@sc_models)
#         end
# 
#         it "should update the sc_models object's attributes" do
#           @sc_models.should_receive(:update_attributes).and_return(true)
#         end
# 
#         it "should redirect to the sc_models's show page" do
#           response.should redirect_to(sc_models_url(@sc_models))
#         end
#       end 
# 
#       describe "with invalid params" do
#         before(:each) do
#           @sc_models = mock_model(sc_models, :update_attributes => false)
#           sc_models.stub!(:find).with("1").and_return(@sc_models)
#         end
# 
#         it "should find sc_models and return object" do
#           sc_models.should_receive(:find).with("1").return(@sc_models)
#         end
# 
#         it "should update the sc_models object's attributes" do
#           @sc_models.should_receive(:update_attributes).and_return(false)
#         end
# 
#         it "should render the edit form" do
#           response.should render_template('edit')
#         end
# 
#         it "should have a flash notice" do
#           flash[:notice].should_not be_blank
#         end  
#       end 
# end   
                 
describe ScModelsController do

  def mock_sc_models(stubs={})
    @mock_sc_models ||= mock_model(ScModel, stubs)
  end

  describe "GET index" do 
    it "assigns all sc_models as @sc_models" do
      ScModel.stub!(:find).with(:all).and_return([mock_sc_models])
      get :index
      assigns[:ScModels].should == [mock_sc_models]
    end
  end

  describe "GET show" do
    it "assigns the requested ScModels as @ScModels" do
      ScModel.stub!(:find).with("37").and_return(mock_sc_models)
      get :show, :id => "37"
      assigns[:ScModels].should equal(mock_sc_models)
    end
  end

  describe "GET new" do
    it "assigns a new ScModels as @ScModels" do
      ScModel.stub!(:new).and_return(mock_sc_models)
      get :new
      assigns[:ScModels].should equal(mock_sc_models)
    end
  end

  describe "GET edit" do
    it "assigns the requested ScModels as @ScModels" do
      ScModel.stub!(:find).with("37").and_return(mock_sc_models)
      get :edit, :id => "37"
      assigns[:ScModels].should equal(mock_sc_models)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created ScModels as @ScModels" do
        ScModel.stub!(:new).with({'these' => 'params'}).and_return(mock_sc_models(:save => true))
        post :create, :ScModels => {:these => 'params'}
        assigns[:ScModels].should equal(mock_sc_models)
      end

      it "redirects to the created ScModels" do
        ScModel.stub!(:new).and_return(mock_sc_models(:save => true))
        post :create, :ScModels => {}
        response.should redirect_to(ScModels_url(mock_sc_models))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ScModels as @ScModels" do
        ScModel.stub!(:new).with({'these' => 'params'}).and_return(mock_sc_models(:save => false))
        post :create, :ScModels => {:these => 'params'}
        assigns[:ScModels].should equal(mock_sc_models)
      end

      it "re-renders the 'new' template" do
        ScModel.stub!(:new).and_return(mock_sc_models(:save => false))
        post :create, :ScModels => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested ScModels" do
        ScModel.should_receive(:find).with("37").and_return(mock_sc_models)
        mock_sc_models.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ScModels => {:these => 'params'}
      end

      it "assigns the requested ScModels as @ScModels" do
        ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => true))
        put :update, :id => "1"
        assigns[:ScModels].should equal(mock_sc_models)
      end

      it "redirects to the ScModels" do
        ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(ScModels_url(mock_sc_models))
      end
    end

    describe "with invalid params" do
      it "updates the requested ScModels" do
        ScModel.should_receive(:find).with("37").and_return(mock_sc_models)
        mock_sc_models.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ScModels => {:these => 'params'}
      end

      it "assigns the ScModels as @ScModels" do
        ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => false))
        put :update, :id => "1"
        assigns[:ScModels].should equal(mock_sc_models)
      end

      it "re-renders the 'edit' template" do
        ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested ScModels" do
      ScModel.should_receive(:find).with("37").and_return(mock_sc_models)
      mock_sc_models.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the ScModelss list" do
      ScModel.stub!(:find).and_return(mock_sc_models(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(ScModelss_url)
    end
  end

end