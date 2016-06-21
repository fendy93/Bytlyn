class Cart < ActiveRecord::Base
	require 'set'
	belongs_to :customer, :foreign_key => 'cust_id', :primary_key => 'user_id'

	def self.current_cart(param)
		@currentVersions = Version.where(cust_id: param)
		cartArrayTotal = Hash.new
		cartArrayId = Hash.new
		cartId = []
		@currentVersions.each do |v|
			@cart = Cart.where(cust_id: param, rest_id: v.rest_id, version: v.count)
			@cart.each do |c|
				# cartId.push(c.id)
				if cartArrayTotal.has_key?(c.rest_id)
					cartArrayTotal[c.rest_id] += (Menu.find(c.menu_id).price * c.qty)
				else
					cartArrayTotal[c.rest_id] = (Menu.find(c.menu_id).price * c.qty)
				end
				if cartArrayId.has_key?(c.rest_id)
					cartArrayId[c.rest_id].push(c.id)
				else
					cartArrayId[c.rest_id] = [c.id]
				end
			end
		end
		return {cart: cartArrayTotal, id: cartArrayId}
	end

	def self.find_cart(cust_id, rest_id, version)
		@cart = Cart.where(cust_id: cust_id, rest_id: rest_id, version: version)
	end
end
