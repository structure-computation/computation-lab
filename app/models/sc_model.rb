class ScModel < ActiveRecord::Base
  
  belongs_to  :user
  belongs_to  :project
  
  has_many    :calcul_results
  
  def has_result? 
    return (rand(1) > 0.5)
  end
  
  def self.save(upload)
    name =  upload['upload'].original_filename
    directory = "public/test"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

  
  
end
