BASE_PRICE = 1000.0
def simulate(log_status = false)
    static_budget = 1_000_000.0
    init_spare_money = 1_000_000.0
    spare_money = init_spare_money
    price = BASE_PRICE
    step_percentage = 1.0
    up_counter = 0

    # coin initiate
    init_coin = 1_000_000 / price
    coin = init_coin


    iteration = 1000
    iteration.times do |i|
        up = [true, false].sample
        up_counter += 1 if up

        price_move = (price * (step_percentage / 100.0))
        price_move *= -1 if !up

        price += price_move

        coin_in_money = price * coin
        budget_coin = static_budget / price

        diff = (coin_in_money - static_budget)

        if (diff > 0) #&& (diff > (static_budget * ((2 * step_percentage) / 100.0)))
            sell_coin = coin - budget_coin
            coin -= sell_coin
            spare_money += (sell_coin * price)
        end

        if diff < 0
            buy_coin = budget_coin - coin
            if spare_money > (buy_coin * price)
                coin += buy_coin
                spare_money -= (buy_coin * price)
            end
        end

        if price <= 5
            #puts "KOIN BANGKRUT at #{i}"
            break
        end
    end

    total_money = (coin * price) + spare_money
    total_money_if_not_moved = ((init_coin * price) + init_spare_money)
    gain = total_money - total_money_if_not_moved

    if log_status
        puts "start money: " + ((init_coin * price) + init_spare_money).to_i.to_s
        puts "total money: " + total_money.to_i.to_s
        puts "total money if not moved: " + total_money_if_not_moved.to_i.to_s
        puts "==="
        puts "gain by moving: " + gain.to_i.to_s
        puts "total coin: " + coin.round(2).to_s
        puts "last price: " + price.round(2).to_s
        puts "up: " + up_counter.to_s
        puts "down: " + (iteration - up_counter).to_s
    end
    return [price, gain]
end


counter = 0
gain_counter = 0
experiment = 1000
gain_sum = 0
puts "Base price ended up in higher"
while counter < experiment
    price, gain = simulate 
    if price > BASE_PRICE
        gain_sum += gain
        counter += 1
        if gain > 0
            gain_counter += 1
        end
    end
end

puts "From #{experiment} times experiment with last price ended up positive, #{gain_counter} times this strategy is more profitable"


counter = 0
gain_counter = 0
gain_sum = 0
puts "Base price ended up in lower"
while counter < experiment
    price, gain = simulate 
    if price < BASE_PRICE
        counter += 1
        gain_sum += gain
        if gain > 0
            gain_counter += 1
        end
    end
end

puts "From #{experiment} times experiment with last price ended up negative, #{gain_counter} times this strategy is more profitable"

counter = 0
gain_counter = 0
puts "Base price ended up in lower"
ended_up_positive = 0
ended_up_negative= 0
gain_sum = 0
while counter < experiment
    counter += 1
    price, gain = simulate 
    gain_sum += gain

    if price > BASE_PRICE
        ended_up_positive += 1
    else
        ended_up_negative += 1
    end

    if gain > 0
        gain_counter += 1
    end
end

puts "From #{experiment} times experiment, #{ended_up_positive} ended up positive, #{ended_up_negative} ended up negative, #{gain_counter} times this strategy is more profitable"