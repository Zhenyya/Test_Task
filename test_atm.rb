require 'yaml'
@data = YAML.load_file(ARGV[0])

$max_cash = 337

def changeMacCash
	money = @data.fetch('banknotes')
	new_max_cash = 0
	money.each do |k, v|
		new_max_cash = new_max_cash + k * v
	end
	$max_cash = new_max_cash
end

def inputAccountNum
	puts "Please Enter Your Account Number: \n"
	acc = STDIN.gets.to_i
end

def inputPass
	puts "Enter Your Password: "
	password = STDIN.gets.chomp
end

def getName (data, account)
	name = @data['accounts'][account]['name']
end

def getBalance (data, account)
	@balance = @data['accounts'][@account]['balance']
end

def newBalance(data, account)
	new_balance = getBalance(@data, @account) - @cash
	@data['accounts'][@account]['balance'] = new_balance
	puts "Your New Balance is #{new_balance}"
	puts "\n"
end

def takeMoney(cash)
	money = @data.fetch('banknotes')
	a = 0
	count_banknote = 0

	money.each do |k, v|
		if (v != 0)
			a = cash / k
			if (v >= a)
				cash = cash - k * a
				count_banknote = a
				#puts k
				#puts count_banknote
				money[k] = v - count_banknote
			else
				cash = cash - k * v
				count_banknote = v
				#puts k
				#puts count_banknote
			end
	    end
	end

	if (cash == 0)
		puts "Please take your money"
		puts "\n"
		@data["banknotes"] = money
		newBalance(@data, @account)
		changeMacCash
		menu
	else
		puts "ERROR: THE AMOUNT YOU REQUESTED CANNOT BE COMPOSED FROM BILLS AVAILABLE IN THIS ATM. PLEASE ENTER A DIFFERENT AMOUNT:"
		checkBalance(@account)
	end
end

def checkBalance(account)
	@cash = STDIN.gets.to_i
	puts "\n"
	if (@cash > getBalance(@data, @account))
		puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT:"
		checkBalance(@account)
	elsif (@cash <= getBalance(@data, @account) && @cash > $max_cash)
		puts "ERROR: THE MAXIMUM AMOUNT AVAILABLE IN THIS ATM IS #{$max_cash}. PLEASE ENTER A DIFFERENT AMOUNT:"
		checkBalance(@account)
	else
		takeMoney(@cash)
	end
end

def menu
	puts "Please Choose From the Following Options:"
	puts "1. Display Balance"
	puts "2. Withdraw"
	puts "3. Logout"
	puts "\n"

	choiced_item = STDIN.gets.strip
	choice = choiced_item.to_i
	puts "\n"

	case choiced_item
	when "1"
		puts "Your Current Balance is ? #{getBalance(@data, @account)}"
		puts "\n"
		menu
	when "2"
		puts "Enter Amount You Wish to Withdraw:"
		checkBalance(@account)
	when "3"
   		puts "#{getName(@data, @account)}, Thank You For Using Our ATM. Good-Bye!"
   		puts "\n"
    	main_menu
	else
		menu
	end
end

def main_menu
	@account = inputAccountNum
	password = inputPass
	puts "\n"
	if @data['accounts'].has_key?(@account) && @data['accounts'][@account]['password'] == password
		puts "Hello, #{getName(@data, @account)}!"
		puts "\n"
		menu
	else
		puts "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH"
		puts "\n"
		main_menu
	end
end

main_menu
