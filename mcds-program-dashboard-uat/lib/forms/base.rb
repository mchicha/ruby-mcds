require 'reform/form/coercion'

class Forms::Base < Reform::Form
  include Coercion

end