# Moip::Transparente

Gem para integração com checkout transparente do MOIP

## Instalação

Coloque no seu Gemfile

```ruby
    gem 'moip-transparente'
```
Rode:

```sh
    $ bundle
```

Ou instale manualmente

```sh
    $ gem install moip-transparente
```

## Como usar

Crie uma instancia de Moip::Checkout no controller

```ruby
@moip = Moip::Checkout.new

invoice = {
  :razao => 'Fatura XXX',
  :id => 1,
  :total => '10.55',
  :acrescimo => '0.00',
  :desconto => '0.00',      
  :cliente => {
    :id => 1,
    :nome => 'Bob Sponja Calça Quadrada',
    :email => 'calquadrada@gmail.com',
    :logradouro => 'Rua X',
    :complemento => 'Qd 11 Lt 2323',
    :bairro => 'Solta Gato',
    :cidade => 'Caixa Prego',
    :uf => 'BA',
    :cep => '00124-11',
    :telefone => '(55) 5555-5555'
  },
  :parcelamentos => [
    {:minimo => 1, :maximo => 10, :repassar => true}
  ]
}

# requisite o token
@moip.get_token(invoice)
```

## View
```html

<%= @moip.javascript_tag %> # Vai gerar o include do Javascript

<%= @moip.widget_tag('paymentSucess', 'paymentFail') %> # Vai gerar o a div do javascript com as funções

```

## Contribuições

1. Faça um fork
2. Crie um novo branch (`git checkout -b my-new-feature`)
3. Commit suas alterações (`git commit -am 'Added some feature'`)
4. Faça um push (`git push origin my-new-feature`)
5. Solicite o pull
