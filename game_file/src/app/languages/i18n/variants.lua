local _ENV, variants
local reverse = function(arr, length)
	local _UPVALUE0_, result
	for i = 1, length do
		result[i] = arr[length - i + 1]
	end
	return result, length
end
local concat = function(arr1, len1, arr2, len2)
	for i = 1, len2 do
		arr1[len1 + i] = arr2[i]
	end
	return arr1, len1 + len2
end
function variants.ancestry(locale)
	reverse = nil
	local result, length, accum = nil, 0
	locale:gsub("[^%-]+", function(c)
		result[length] = accum
	end)
	return reverse(result, length)
end
function variants.isParent(parent, child)
	return not not child:match("^" .. parent .. "%-")
end
function variants.root(locale)
	return locale:match("[^%-]+")
end
function variants.fallbacks(locale, fallbackLocale)
	if locale == fallbackLocale or variants.isParent(fallbackLocale, locale) then
		return variants.ancestry(locale)
	end
	if variants.isParent(locale, fallbackLocale) then
		return variants.ancestry(fallbackLocale)
	end
	local ancestry1, length1 = variants.ancestry(locale)
	local ancestry2, length2 = variants.ancestry(fallbackLocale)
	return concat(ancestry1, length1, ancestry2, length2)
end
return variants
