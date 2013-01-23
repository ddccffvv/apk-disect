def print_binary_string string
    string.each_byte do |b|
        print b.to_s(16).rjust(2, "0")
        print " "
    end
    puts " "
end

def binary_to_integer string
    temp = ""
    string.each_byte do |b|
        temp = temp + b.to_s(16).rjust(2, "0")
    end
    temp.to_i(16)
end

def get_string_by_id id, f
    puts "in get by id"
    puts id
    offset = $string_ids[id]
    puts offset
    f.seek(offset, IO::SEEK_SET)
    len = binary_to_integer f.read(1)
    f.read(len)
end

f = open("classes.dex", "rb")

header = f.read(8)

print_binary_string header

#endianness = f.read(4)
#print_binary_string endianness


f.seek(36, IO::SEEK_SET)
constant = f.read(4)

print_binary_string constant

endianness = f.read(4)
print_binary_string endianness

print "Link size  : "
print_binary_string f.read(4).reverse
print "Link offset: "
print_binary_string f.read(4).reverse
print "Map offset:  "
print_binary_string f.read(4).reverse
print "String ids size:  "
string_number = f.read(4).reverse
print_binary_string string_number
puts "there are #{binary_to_integer string_number} strings"
print "String ids offset:  "
string_offset = f.read(4).reverse
print_binary_string string_offset
print "type size  : "
print_binary_string f.read(4).reverse
print "type offset: "
print_binary_string f.read(4).reverse
print "proto size  : "
print_binary_string f.read(4).reverse
print "proto offset: "
print_binary_string f.read(4).reverse
print "field size  : "
print_binary_string f.read(4).reverse
print "field offset: "
print_binary_string f.read(4).reverse
print "method size  : "
method_size = f.read(4).reverse
print_binary_string method_size 
print "method offset: "
method_offset = f.read(4).reverse
print_binary_string method_offset
print "class size  : "
print_binary_string f.read(4).reverse
print "class offset: "
print_binary_string f.read(4).reverse




puts "string ids:"
f.seek(binary_to_integer(string_offset), IO::SEEK_SET)
$string_ids = []
(0...binary_to_integer(string_number)).each do |i|
    $string_ids << binary_to_integer( f.read(4).reverse)
end



$string_ids.each do |offset|
    f.seek(offset, IO::SEEK_SET)
    len = binary_to_integer f.read(1)
    puts f.read(len)
end

f.seek(binary_to_integer(method_offset), IO::SEEK_SET)
(0...binary_to_integer(method_size)).each do |i|
    f.read(4)
    temp = f.read(4).reverse
    print_binary_string temp
    puts get_string_by_id binary_to_integer(temp), f
    puts "--------------"
end

puts binary_to_integer string_offset 
puts binary_to_integer method_size
puts binary_to_integer method_offset
