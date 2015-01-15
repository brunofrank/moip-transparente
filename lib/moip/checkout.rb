require 'xml'
require 'base64'

class Moip::Checkout
  
  def javascript_tag
    "<script type='text/javascript' src='#{get_javascript_url}' charset='ISO-8859-1'></script>"
  end
  
  def widget_tag(success, fail)
    "<div id='MoipWidget'
          data-token='#{@token}'
          callback-method-success='#{success}' 
          callback-method-error='#{fail}'>
    </div>"
  end

  def get_token(invoice)
    doc = XML::Document.new
    doc.root = XML::Node.new('EnviarInstrucao')    

    unica = XML::Node.new('InstrucaoUnica')
    unica['TipoValidacao'] = 'Transparente'

    
    description = XML::Node.new('Razao')
    description << invoice[:razao]
    unica << description
    
    id_invoice = XML::Node.new('IdProprio')
    id_invoice << invoice[:id]
    unica << id_invoice

    valores = XML::Node.new('Valores')

    valor = XML::Node.new('Valor')
    valor['moeda'] = 'BRL'
    valor << invoice[:total]
    valores << valor
        
    acrescimo = XML::Node.new('Acrescimo')
    acrescimo['moeda'] = 'BRL'
    acrescimo << invoice[:acrescimo]  || '0.00'    
    valores << acrescimo

    deducao = XML::Node.new('Deducao')
    deducao['moeda'] = 'BRL'
    deducao << invoice[:desconto]  || '0.00'    
    valores << deducao

    unica << valores    
    
    pagador = XML::Node.new('Pagador')
    nome = XML::Node.new('Nome')
    nome << invoice[:cliente][:nome]    
    pagador << nome
    
    email = XML::Node.new('Email')
    email << invoice[:cliente][:email]    
    pagador << email

    id = XML::Node.new('IdPagador')
    id << invoice[:cliente][:id]   
    pagador << id     
    
    endereco = XML::Node.new('EnderecoCobranca')

    logradouro = XML::Node.new('Logradouro')
    logradouro << invoice[:cliente][:logradouro]
    endereco << logradouro
    
    numero = XML::Node.new('Numero')
    numero_or_default = invoice[:cliente][:numero] || '0'
    numero << numero_or_default
    endereco << numero
    
    complemento = XML::Node.new('Complemento')
    complemento << invoice[:cliente][:complemento]
    endereco << complemento
        
    bairro = XML::Node.new('Bairro')
    bairro << invoice[:cliente][:bairro]    
    endereco << bairro

    cidade = XML::Node.new('Cidade')
    cidade << invoice[:cliente][:cidade]        
    endereco << cidade

    estado = XML::Node.new('Estado')                        
    estado << invoice[:cliente][:uf]        
    endereco << estado

    pais = XML::Node.new('Pais')
    pais_or_default = invoice[:cliente][:pais] || 'BRA'
    pais << pais_or_default
    endereco << pais

    cep = XML::Node.new('CEP')
    cep << invoice[:cliente][:cep]    
    endereco << cep

    telefone = XML::Node.new('TelefoneFixo')
    telefone << invoice[:cliente][:telefone]      
    endereco << telefone
    
    pagador << endereco
    unica << pagador    
    
    parcelamentos = XML::Node.new('Parcelamentos')
    invoice[:parcelamentos].each do |parcelamento_item|
      parcelamento = XML::Node.new('Parcelamento')                
      minimo = XML::Node.new('MinimoParcelas')
      minimo << parcelamento_item[:minimo]
      parcelamento << minimo

      maximo = XML::Node.new('MaximoParcelas')
      maximo << parcelamento_item[:maximo]
      parcelamento << maximo

      if parcelamento_item[:repassar]
        repassar = XML::Node.new('Repassar')
        repassar << '1'
        parcelamento << repassar
      else
        juros = XML::Node.new('Juros')
        juros <<  parcelamento_item[:juros]        
        parcelamento << juros
      end  
      parcelamentos << parcelamento          
    end
    
    unica << parcelamentos
    
    comissoes = XML::Node.new('Comissoes')                
    if invoice[:comissoes]
      invoice[:comissoes].each do |comissao_item|
        comissionamento = XML::Node.new('Comissionamento')
        razao = XML::Node.new('Razao')
        razao << comissao_item[:razao] || invoice[:razao]
        comissionamento << razao
      
        comissionado = XML::Node.new("Comissionado")
        login_moip = XML::Node.new("LoginMoIP")
        login_moip << comissao_item[:login_moip]
        comissionado << login_moip
        comissionamento << comissionado
      
        valor = XML::Node.new("ValorFixo")
        valor << comissao_item[:valor]
        comissionamento << valor
        comissoes << comissionamento
      end    
    end
    
    if invoice[:pagador_taxas]
      taxas = XML::Node.new('PagadorTaxa')      
      login_moip = XML::Node.new("LoginMoIP")
      login_moip <<  invoice[:pagador_taxas]
      taxas << login_moip
      comissoes << taxas
    end
    
    unica << comissoes    
    
    doc.root << unica

    parser = XML::Parser.string(Moip::MoipRequest.post_data(doc.to_s).body)
    dom = parser.parse 
    resposta = dom.find('./Resposta').first
    if resposta.find('Status')[0].content  == 'Sucesso'
      @token = resposta.find('Token')[0].content
      return {:status => :ok, :token => resposta.find('Token')[0].content, :id => resposta.find('ID')[0].content}
    elsif resposta.find('Status')[0].content  == 'Falha'
      return {:status => :fail, :code => resposta.find('Erro')[0]['Codigo'], :message => resposta.find('Erro')[0].content, :id => resposta.find('ID')[0].content }
    end    
  end
  
  private
  
  

  def get_javascript_url
    if Moip::Config.test?
      return "https://desenvolvedor.moip.com.br/sandbox/transparente/MoipWidget-v2.js"
    else
      return "https://www.moip.com.br/transparente/MoipWidget-v2.js"
    end
  end  

end