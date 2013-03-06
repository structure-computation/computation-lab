# encoding: utf-8

class TokenAccount < ActiveRecord::Base
  belongs_to :workspace
  has_many   :solde_token_accounts
  has_many   :credits
  has_many   :log_tools
  
  # initialisation d'un nouveau compte lors de la création d'une nouvelle workspace
  def init()  
    self.status = 'active'
    self.used_token_counter = 0
    self.purchased_token_counter = 0
    self.reserved_token = 0
    self.solde_token = 0
    
    new_solde_token_account = self.solde_token_accounts.new()
    new_solde_token_account.log_tool_id = -1
    new_solde_token_account.credit_id = -1
    new_solde_token_account.credit_token = 0
    new_solde_token_account.used_token = 0
    new_solde_token_account.solde_token = 0
    new_solde_token_account.solde_type = "workspace_initialisation"
    new_solde_token_account.save

    self.save
  end
  
  def valid_credit(credit_id)
    current_credit = self.credits.find(credit_id)
    #mise a jour des info du compte
    self.purchased_token_counter += current_credit.nb_token
    self.status = 'active'
    self.make_solde()
    
    #mise à jour du solde_calcul_accounts
    current_solde = self.solde_token_accounts.build()
    current_solde.credit = current_credit
    current_solde.solde_type = 'token'
    current_solde.credit_token = current_credit.nb_token
    current_solde.used_token = 0
    current_solde.solde_token = self.solde_token
    current_solde.save
    
    #derniere mise a jour des info du compte et sauvegarde
    logger.debug "self.solde_token : " + self.solde_token.to_s
    self.save
  end
  
  def valid_log_tool(log_tool_id)
    current_log_tool = self.log_tools.find(log_tool_id)
    logger.debug "current_log_tool : " + current_log_tool.launch_state.to_s
    #mise a jour des info du compte
    self.used_token_counter += current_log_tool.nb_token
    self.status = 'active'
    self.make_solde()
    
    #mise à jour du solde_calcul_accounts
    current_solde = self.solde_token_accounts.build()
    current_solde.log_tool = current_log_tool
    current_solde.solde_type = current_log_tool.log_type
    current_solde.credit_token = 0
    current_solde.used_token = current_log_tool.nb_token
    current_solde.solde_token = self.solde_token
    current_solde.save
    
    #derniere mise a jour des info du compte et sauvegarde
    logger.debug "self.solde_token : " + self.solde_token.to_s
    self.save
  end
  
  def make_solde()
    self.active_purchased_token_counter = 0
    self.active_used_token_counter = 0
    self.purchased_token_counter = 0
    self.used_token_counter = 0
    self.solde_token = 0
    credits = self.credits.find(:all, :conditions => {:state => "active"})
    credits.each  do |cred|
      self.active_purchased_token_counter += cred.nb_token
      self.active_used_token_counter += cred.used_token
      self.purchased_token_counter += cred.nb_token
    end
    
    log_tools = self.log_tools.find(:all, :conditions => {:launch_state => "finish"})
    logger.debug "log_tools : " + log_tools.to_s
    log_tools.each  do |log|
      self.used_token_counter += log.nb_token
    end
    self.solde_token = self.purchased_token_counter - self.used_token_counter
    self.save 
  end
  
  def reserve_token?(nb_token)
    reserved = false
    reserved_token = nb_token
    log_tools = self.log_tools.find(:all)
    log_tools.each  do |log|
      if log.ready?()
        reserved_token += log.nb_token
      end
    end
    logger.debug "reserved_token : "  + reserved_token.to_s
    if reserved_token <= self.solde_token
      reserved = true
    end
    return reserved
  end
  
  def reserve_token()
    self.reserved_token = 0
    log_tools = self.log_tools.find(:all)
    log_tools.each  do |log|
      if log.ready?()
        self.reserved_token += log.nb_token
      end
    end
    logger.debug "self.reserved_token : "  + self.reserved_token.to_s
    self.save 
  end
  
end
