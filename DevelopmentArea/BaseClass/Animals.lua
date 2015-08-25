Animals = {}
Animals_mt = { __index = Animals }

-- This function creates a new instance of Animals
--
function Animals:create()
    local new_inst = {}    -- the new instance
    setmetatable( new_inst, Animals_mt ) -- all instances share the same metatable
    return new_inst
end

-- Here are some functions (methods) for Animals:

function Animals:className()
    print( "Animals" )
end

function Animals:doSomething()
    print( "Doing something" )
end

-- Create a new class that inherits from a base class
--
function inheritsFrom( baseClass )

    -- The following lines are equivalent to the Animals example:

    -- Create the table and metatable representing the class.
    local new_class = {}
    local class_mt = { __index = new_class }

    -- Note that this function uses class_mt as an upvalue, so every instance
    -- of the class will share the same metatable.
    --
    function new_class:create()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    -- The following is the key to implementing inheritance:

    -- The __index member of the new class's metatable references the
    -- base class.  This implies that all methods of the base class will
    -- be exposed to the sub-class, and that the sub-class can override
    -- any of these methods.
    --
    if baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end

    return new_class
end