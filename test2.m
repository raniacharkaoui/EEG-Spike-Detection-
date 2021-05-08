x = 1;
order_channels = [9 1 5 13 19 10 2 17 6 14 21 20 11 3 18 7 15 22 12 4 8 16];
x1 = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22];
for i = 1 : 1 : length(order_channels)
        index = order_channels(i);
        x2(index) = x1(i); %list of values for next channels
        stop = x2(index)-1;
        if index == 1
            start = 1;
        else
            start = x1(index-1)+1;
        end
end
