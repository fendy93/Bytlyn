class Delivery < ActiveRecord::Base

	def self.get_delivery_cust(params)
		return Delivery.where(user_id: params[0])
	end

	def self.get_delivery_rest(params)
		return Delivery.where(rest_id: params)
	end

	def self.get_order(params)
		@cart = Cart.where(cust_id: params[:user_id], rest_id: params[:rest_id], version: params[:version])
		menuArray = []
		@cart.each do |c|
			menu = Menu.find(c.menu_id)
			menuArray.push(menu.name)
		end
		return menuArray
	end

	# def self.get_customer_delivery(user_id)
	# 	return Delivery.where(user_id: user_id).where("status < ?", 4)

	# end
	def self.get_customer_delivery(user_id)
		delivery_list = Delivery.where(user_id: user_id).where("status < ?", 4)
		list_and_cart = []
		delivery_list.each do |delivery|
			this_cart = Cart.find_cart(delivery.user_id, delivery.rest_id, delivery.version)
			this_menu = []
			this_cart.each do |cart|
				menu = Menu.find(cart.menu_id)
				this_menu << {name: menu.name, qty: cart.qty, price: menu.price}
			end

			list_and_cart << {:delivery => delivery, :cart => this_menu}
		end
		return list_and_cart
	end

	def self.get_restaurant_delivery(user_id)
		delivery_list = Delivery.where(rest_id: user_id).where("status < ?", 4)
		list_and_cart = []
		delivery_list.each do |delivery|
			this_cart = Cart.find_cart(delivery.user_id, delivery.rest_id, delivery.version)
			this_menu = []
			this_cart.each do |cart|
				this_menu << {name: Menu.find(cart.menu_id).name, qty: cart.qty}
			end

			list_and_cart << {:delivery => delivery, :cart => this_menu}
		end
		return list_and_cart
	end

	def self.get_customer_delivery_history(user_id)
		delivery_list = Delivery.where(user_id: user_id, status: 4)
		list_and_cart = []
		delivery_list.each do |delivery|
			this_cart = Cart.find_cart(delivery.user_id, delivery.rest_id, delivery.version)
			this_menu = []
			this_cart.each do |cart|
				this_menu << {name: Menu.find(cart.menu_id).name, qty: cart.qty}
			end

			list_and_cart << {:delivery => delivery, :cart => this_menu}
		end
		return list_and_cart

	end

	def self.get_restaurant_delivery_history(user_id)
		delivery_list = Delivery.where(rest_id: user_id, status: 4)
		list_and_cart = []
		delivery_list.each do |delivery|
			this_cart = Cart.find_cart(delivery.user_id, delivery.rest_id, delivery.version)
			this_menu = []
			this_cart.each do |cart|
				this_menu << {name: Menu.find(cart.menu_id).name, qty: cart.qty}
			end

			list_and_cart << {:delivery => delivery, :cart => this_menu}
		end
		return list_and_cart
	end

	def self.status_string(status)
		case status
			when 1
				'Order Processed'
			when 2
				'Preparing Order'
			when 3
				'On The Way'
			when 4
				'Delivered'
			else
				'Unknown'
		end
	end



end
