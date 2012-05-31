class LogTool < ActiveRecord::Base
  
  belongs_to  :sc_model
  belongs_to  :calcul_result
  belongs_to  :workspace_member, :class_name => "UserWorkspaceMembership", :foreign_key => "workspace_member_id"
  belongs_to  :token_account
  has_one     :workspace ,  :through => :token_account
  has_one     :solde_token_account
  
  #launch_state = ['pending', 'ready', 'in_process', 'finish', 'echec']
  #state = ['temp', 'pending', 'in_process', 'finish', 'echec', 'downloaded', 'uploaded']
  #log_type = ['scult', 'scills', 'sceen', 'script']
  
  
  def pending?()
    void = false
    if self.launch_state == "pending"
      void = true
    else
      void = false
    end
    return void
  end
  
  def ready?()
    void = false
    if self.launch_state == "ready" or self.launch_state == "in_process"
      void = true
    else
      void = false
    end
    return void
  end
  
  def finish?()
    void = false
    if self.launch_state == "finish"
      void = true
    else
      void = false
    end
    return void
  end
  
  def pending()
    self.launch_state = "pending"
    self.save
  end
  
  def ready()
    self.launch_state = "ready"
    self.save
  end
  
  def in_process()
    self.launch_state = "in_process"
    if self.log_type == "scills"
      self.calcul_result.calcul_in_process()
    end
    self.save
  end
  
  def finish()
    self.launch_state = "finish"
    self.save
  end
  
  def echec()
    self.launch_state = "echec"
    self.save
  end

  def get_launch_autorisation()
    self.launch_autorisation = false
    logger.debug "token à débiter : " + self.nb_token.to_s
    logger.debug "solde du compte : " + self.token_account.solde_token.to_s
    logger.debug "reserve du compte : " + self.token_account.reserved_token.to_s
    
    if self.token_account.reserve_token?(self.nb_token)
      self.launch_autorisation = true
    else                                       #si il y a assez de jetons , les jetons sont placé sur la reserve                                
      self.launch_autorisation = false
    end
    self.save
    return self.launch_autorisation
  end
  
  def reserve_token()
    self.token_account.reserve_token()
  end
  
  # validation d'un log pour scult ---------------------------------------------------------------
  def scult_valid(params)
    calcul_state = Integer(params[:state]) 
    if(calcul_state == 0) #si le calcul est arrivé au bout 
      self.sc_model.mesh_valid()
      self.real_time = params[:time]
      self.finish()
      self.token_account.valid_log_tool(self.id)
      self.reserve_token()
    else
      self.sc_model.state = "echec"
      self.real_time = params[:time]
      self.echec()
      self.reserve_token()
    end
  end
  
  
  # validation d'un log pour scills ---------------------------------------------------------------
  def scills_valid(params)
    calcul_state = Integer(params[:state]) 
    if(calcul_state == 0) #si le calcul est arrivé au bout 
      self.calcul_result.calcul_valid(params)
      self.real_time = params[:time]
      self.finish()
      self.token_account.valid_log_tool(self.id)
      self.reserve_token()
    else
      self.calcul_result.calcul_echec(params)
      self.real_time = params[:time]
      self.echec()
      self.reserve_token()
    end
  end
  
end
