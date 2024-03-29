# encoding: utf-8

class LogTool < ActiveRecord::Base
  
  belongs_to  :sc_model
  belongs_to  :calcul_result
  belongs_to  :workspace_member, :class_name => "UserWorkspaceMembership", :foreign_key => "workspace_member_id"
  belongs_to  :token_account
  has_one     :workspace ,  :through => :token_account
  has_one     :solde_token_account
  
  belongs_to  :application
  
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
  
  def in_use?()
    void = false
    current_time = Time.now.utc
    end_time = self.created_at + 1.hours
    logger.debug "current_time    = " + current_time.to_s
    logger.debug "end_time        = " + end_time.to_s
    logger.debug "self.created_at = " + self.created_at.to_s
    if current_time > end_time
      void = false
    else
      void = true
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
  
  def deleted()
    self.launch_state = "deleted"
    self.state = "deleted"
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
  
  # décompte du temps d'utilisation des outils ---------------------------------------------------------------
  def use_tool_for_one_hour(name_tool)
    self.log_type = "use_" + name_tool
    self.nb_token = 1
    if name_tool == "sceen"
      self.nb_token = 5
    elsif name_tool == "scills"
      self.nb_token = 2
    end
    logger.debug "nb_token = " + self.nb_token.to_s
    
    self.real_time = 3600
    self.finish()
    self.token_account.valid_log_tool(self.id)
    self.reserve_token()
  end
  
  # décompte du temps d'utilisation des outils ---------------------------------------------------------------
  def use_tool_type(type_app)
    if type_app == 0                    # gratuis
      self.nb_token = 0
    elsif type_app == 1                 # fixe
      self.nb_token = 1
    elsif type_app == 2                 # nb minute/proc
      self.nb_token = ((self.real_time * self.cpu_allocated)/60).ceil+1
    end
    logger.debug "nb_token = " + self.nb_token.to_s
    
    self.finish()
    self.token_account.valid_log_tool(self.id)
    self.reserve_token()
  end
end
