class Moip::MoipRequest
	include HTTParty
	format :xml
	def self.post_data(xml)
		self.base_uri get_token_url
		basic_auth Moip::Config.access_token, Moip::Config.access_key
    post("EnviarInstrucao/Unica",:body => xml)
  end 
  private
  def self.get_token_url
    if Moip::Config.test?
      return "https://desenvolvedor.moip.com.br/sandbox/ws/alpha/EnviarInstrucao/Unica"
    else
      return "https://www.moip.com.br/ws/alpha/EnviarInstrucao/Unica"
    end
  end
end