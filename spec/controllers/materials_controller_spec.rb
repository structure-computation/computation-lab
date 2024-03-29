require 'spec_helper'

describe MaterialsController do 
  
  # NOTE: Il semble important d'adopter une convention de nommage : mock_ pour les objet mock, un nom non préfixé
  # pour les objets issus des factories.
  let :mock_material            do mock_model(Material).as_null_object              end
  let :current_workspace        do FactoryGirl.build(:workspace)                    end
  let :mock_workspace_member    do 
    mock_model(UserWorkspaceMembership, :workspace    => current_workspace ).as_null_object 
  end
  
  # NOTE: pour screencast : before != begin... et before(:all) ne marche pas pour cela : controller n'est pas 
  # encore défini !
  # NOTE: Attention, seul before each est placé dans une transaction pour la BDD. 
  before(:each) do
    controller.stub(:authenticate_user!       =>  true              ) # .and_return(true)
    controller.stub(:current_workspace_member =>  mock_workspace_member )    
    @standard_material   = FactoryGirl.create(:standard_material )
    @workspace_material  = FactoryGirl.create(:material , :workspace =>  current_workspace )  
    # @standard_material.save    
    # @workspace_material.save   
  end  
  describe "Access for engineers roles" do
    before(:each) do mock_workspace_member.stub(:engineer? => true) end
    context "When accessing standard materials" do
      it "can access index" do get    :index  , :workspace_id => current_workspace.id;                                  should respond_with(:success)   end
      it "can access show"  do get    :show   , :workspace_id => current_workspace.id, :id => @standard_material.id ;   should respond_with(:success)   end
      # it "can NOT edit"     do get    :edit   , :workspace_id => current_workspace.id, :id => @standard_material.id ;   should respond_with(:forbidden) end
      # it "can NOT update"   do put    :update , :workspace_id => current_workspace.id, :id => @standard_material.id ;   should respond_with(:forbidden) end
      # it "can NOT destroy"  do delete :destroy, :workspace_id => current_workspace.id, :id => @standard_material.id ;   should respond_with(:forbidden) end    
      # new et create non pertinents sur un standard material
    end
  end
      
  describe "Access for non engineers roles" do
    before(:each) do mock_workspace_member.stub(:engineer? => false) end
    context "When accessing standard materials" do
      it "can access index" do get    :index  , :workspace_id => current_workspace.id;                                  should respond_with(:forbidden) end
      it "can access show"  do get    :show   , :workspace_id => current_workspace.id, :id => @workspace_material.id ;  should respond_with(:forbidden) end
      it "can NOT edit"     do get    :edit   , :workspace_id => current_workspace.id, :id => @workspace_material.id ;  should respond_with(:forbidden) end
      it "can NOT update"   do put    :update , :workspace_id => current_workspace.id, :id => @workspace_material.id ;  should respond_with(:forbidden) end
      it "can NOT destroy"  do delete :destroy, :workspace_id => current_workspace.id, :id => @workspace_material.id ;  should respond_with(:forbidden) end  
    end
                                                                                   
        

  end   
end
  # end
  #                            
  # 
  # describe "GET show" do
  #   
  #   it "assigns the requested material as @material if material is a standard material" do
  #     get :show, :id => @standard_material.id 
  #     assigns(:material).should eq(@standard_material)    
  #     response.should render_template("materials/show") 
  #   end    
  #   
  #   it "assigns the requested material as @material if material is a a material from current workspace." do
  #     get :show, :id => @workspace_material.id
  #     assigns(:material).should eq(@workspace_material)
  #     response.should render_template("materials/show")
  #   end
  #   
  #   context "When a forbidden (outside of current_workspace) or non existant material is asked" do 
  #     before(:each) do
  #       other_workspace                 = FactoryGirl.create(:workspace)
  #       @material_from_other_workspace  = FactoryGirl.create(:material, :workspace => other_workspace)
  # 
  #       # Construction puis destruction d'un matériel pour avoir un id inexistant
  #       tmp_material                    = FactoryGirl.create(:material)
  #       @non_existing_material_id       = tmp_material.id
  #       tmp_material.destroy
  #     end
  #     
  #     it "in html, redirect to materials list if the requested material belongs to an other workspace than current workspace." do
  #       get :show, :id => @material_from_other_workspace.id
  #       assigns(:material).should be nil
  #       response.should redirect_to(workspace_materials_path(current_workspace))
  #       flash[:notice].should eq("Ce matériel n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
  #     end    
  #   
  #     it "in html, redirect to materials list if no material is available with this id." do
  #       # Get de l'id inexistant.
  #       get :show, :id => @non_existing_material_id
  #       assigns(:material).should be nil
  #       response.should redirect_to(workspace_materials_path(current_workspace))
  #       flash[:notice].should eq("Ce matériel n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
  #     end
  #     
  #     it "in json, send a 404 error if the requested material belongs to an other workspace than current workspace." do
  #       get :show, :format => "json", :id => @material_from_other_workspace.id
  #       assert_response 404
  #     end
  #     
  #     it "in json, send a 404 error if no material is available with this id." do
  #       get :show, :format => "json", :id => @non_existing_material_id
  #       assert_response 404
  #     end
  #   end
  # end     
  # 
  #   describe "DELETE destroy" do         
  #     # TODO: Ajouter une condition si User == MaterialOwner
  #     before (:each) do
  #       @material_to_destroy  = FactoryGirl.create(:material, :workspace => current_workspace) 
  #     end
  #     it "destroys the requested material" do
  #       pending "Il faut préciser que cette action de controlleur n'a pas besoin d'une vue."
  #       # get :destroy, :workspace_id => current_workspace.id, :id => @material_to_destroy.id      
  #       # response.should redirect_to(workspace_materials_path(current_workspace))
  #     end
  #   end      
  # end 
  # 
  #                                                                         