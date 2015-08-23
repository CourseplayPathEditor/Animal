-- Create a new class that inherits from Animals
Animal = inheritsFrom( Animals )

-- override className() function
function Animal:className() 
print( "Animal" ) 
end

-- Create an instance of Animals
simple = Animals:create()
 
simple:className()
simple:doSomething()
-- Create an instance of SubClass
sub = Animal:create()

sub:className()  -- Call overridden method
sub:doSomething()  -- Call base class method