# -*- encoding: utf-8 -*-
require 'test_helper'

class CheckoutTest < TestHelper

  def setup
    @moip = Moip::Checkout.new
  end
  
  def test_get_token
    invoice = {
      :razao => 'Cobrança so site XXX',
      :id => rand(999),
      :total => '10.55',
      :acrescimo => '0.00',
      :desconto => '0.00',      
      :cliente => {
        :id => 111,
        :nome => 'Bruno Frank Silva Cordeiro',
        :email => 'bfscordeiro@gmail.com',
        :logradouro => 'Rua 3-E',
        :complemento => 'Qd 40 Lt 01 Cs 4',
        :bairro => 'Garavelo',
        :cidade => 'Aparecida de Goiânia',
        :uf => 'GO',
        :cep => '74932-180',
        :telefone => '(62) 3288-5334'
      },
      :parcelamentos => [
        {:minimo => 1, :maximo => 10, :repassar => true}
      ]
    }

    response = @moip.get_token(invoice)
    @token = response[:token]
    assert_equal response[:status], :ok
  end
  
  def test_widget
    expected = "<div id='MoipWidget'
          data-token='#{@token}'
          callback-method-success='success' 
          callback-method-error='fail'>
    </div>"
    
    widget = @moip.widget_tag('success', 'fail')
    
    assert_equal widget, expected
  end
  
  def test_script
    assert_equal @moip.javascript_tag, "<script type='text/javascript' src='https://desenvolvedor.moip.com.br/sandbox/transparente/MoipWidget-v2.js' charset='ISO-8859-1'></script>"
  end
end