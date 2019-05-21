module Controllers
  module ApplicationHelpers

    def stub_required_objects
      @user = FactoryGirl.create(:user, :with_cas_id, :created_programs)
      ApplicationController.any_instance.stub(:require_user)
    end

    def stub_abilities
      # Stub out cancan ability
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability).and_return(@ability)
    end

  end
end
