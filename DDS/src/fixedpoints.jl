function detect_orbits(
        FP,
        map,
        param,
        order,
        seed,
        β;
        disttol::Real = 1e-12,
        bintol::Real=1e-8
    )
    rule = nth_composition(map, order)
    g(x) = rule(x, param) - x
    for C in [-1, 1]
        _detect_orbits!(map, param, order, seed, C, β, disttol, FP, g, bintol)
    end
end

function _detect_orbits!(map, param, order, seed, C, β, disttol, FP, g, bintol)
    seed = to_array(seed)
    container = Vector{Float64}(undef, order+1)
    for x in seed
        for _ in 1:max(100, 4*β)
            xn = DL_rule(x, β, C, g)
            if abs(g(xn)) < disttol
                add_fps!(container, map, g, FP, xn, param, order, disttol, bintol)
                break
            end
            x = xn
        end
    end
end

function add_fps!(container, map, g, FP, xn, param, order, disttol, bintol)
    iterate!(map, xn, param, order, container) 
    for e in container
        e, _ = newton_raphson(g, x->ForwardDiff.derivative(g, x), e, 5)
        if abs(g(e)) < disttol 
            if !search(FP, e, bintol)
                insert!(FP, e, bintol)
            end
        end
    end
end

function DL_rule(x, β, C, g)
    Jx = ForwardDiff.derivative(g, x)
    gx = g(x)
    xn = x + 1/(β*abs(gx)*C - Jx) * gx
    return xn
end

function DL(
        map,
        param,
        order,
        x_range;
        bintol::Float64 = 1e-8,
        kwargs...
    )
    fps = [BinarySearchTree{Float64}(nothing)]
    l = length(fps[1])
    a = 1.0
    seed = to_seed(LinRange(x_range..., max(30, 5*order)), bintol)
    while true
        β = exp(a)
        detect_orbits(fps[1], map, param, order, seed, β;bintol=bintol,kwargs...)
        new_l = length(fps[1])
        if new_l == l
            break
        else
            l = new_l
            a += 1.0
        end
    end
    return fps[1]
end

function fixed_points(map, param, order, x_range)
    disttol = 1e-8
    bintol = 1e-5
    return to_array(DL(map, param, order, x_range;disttol=disttol, bintol=bintol))
end

function stable_fixed_points(map, param, order, x_range)
    fps = fixed_points(map, param, order, x_range)
    filter!(x0->is_stable(nth_composition(map, order), x0, param), fps) 
    return fps
end

function create_seeds(map, param, max_order, x_range)
    res = Vector{Vector{Float64}}(undef, max_order)
    for i = 1:max_order
        res[i] = fixed_points2(map, param, i, x_range)
    end
    return res
end

# Define a binary search tree node
mutable struct TreeNode{T}
    data::T
    left::Union{TreeNode{T}, Nothing}
    right::Union{TreeNode{T}, Nothing}
end

# Binary search tree type
mutable struct BinarySearchTree{T}
    root::Union{TreeNode{T}, Nothing}
end

# Function to insert a value into the BST
function insert!(tree::BinarySearchTree, value, tol)
    tree.root = _insert(tree.root, value, tol)
end

# Helper function for insertion
function _insert(node, value, tol)
    if isnothing(node)
        return TreeNode(value, nothing, nothing)
    end
    if value < node.data.-tol
        node.left = _insert(node.left, value, tol)
    elseif value > node.data .+ tol
        node.right = _insert(node.right, value, tol)
    end

    return node
end

# Function to search for a value in the BST
function search(tree::BinarySearchTree, value, tol)
    return _search(tree.root, value, tol)
end

# Helper function for search
function _search(node, value, tol)
    if isnothing(node)
        return false
    end

    if abs(value - node.data) <= tol
        return true
    elseif value < node.data.-tol
        return _search(node.left, value, tol)
    elseif value > node.data.+tol
        return _search(node.right, value, tol)
    end
end

function to_array(bst::BinarySearchTree)
    len = length(bst)
    type = typeof(bst).parameters[1]
    arr = Vector{type}(undef, len)
    index = 1
    _to_array!(bst.root, arr, index)
    return arr
end

function _to_array!(node, arr, index)
    if !isnothing(node)
        index = _to_array!(node.left, arr, index)
        arr[index] = node.data
        index += 1
        index = _to_array!(node.right, arr, index)
    end
    return index
end

import Base.length
function length(bst::BinarySearchTree)
    return _length(bst.root)
end

function _length(node)
    if isnothing(node)
        return 0
    else
        return _length(node.left) + 1 + _length(node.right)
    end
end

function to_seed(arr, bintol)
    bst = BinarySearchTree{Float64}(nothing)
    [insert!(bst, x, bintol) for x in arr]
    return bst

end

function newton_raphson(f, df, x0, max_iterations=100, tolerance=1e-10)
    x = x0
    for _ in 1:max_iterations
        x -= f(x) / df(x)
        if abs(f(x)) < tolerance
            return x, true
        end
    end
    x, false
end