local _ENV, tableUtil
function tableUtil.deepMerge(dest, src)
	for k, v in pairs(src) do
		if type(v) == "table" then
			if dest[k] == nil then
				dest[k] = v
			elseif type(dest[k]) == "table" then
				tableUtil.deepMerge(dest[k], v)
			else
				print("tableUtil.deepMerge type not same")
			end
		else
			dest[k] = v
		end
	end
end
function tableUtil.except(dest, src)
	for k, v in pairs(src) do
		if dest[k] then
			if type(v) == "table" and type(dest[k]) == "table" then
				tableUtil.except(dest[k], v)
			else
				dest[k] = nil
			end
		end
	end
	return dest
end
function tableUtil.getMergeTab(oldTab, newTab)
	local _ENV, mergeTab
	for k, v in pairs(newTab) do
		if oldTab[k] == nil then
			mergeTab[k] = v
		elseif type(v) ~= type(oldTab[k]) then
			mergeTab[k] = v
		elseif type(v) == "table" then
			mergeTab[k] = tableUtil.getMergeTab(oldTab[k], v)
		elseif v ~= oldTab[k] then
			mergeTab[k] = v
		end
	end
	return next(mergeTab) and mergeTab or nil
end
function tableUtil.getExceptTab(oldTab, newTab)
	local _ENV, exceptTab
	for k, v in pairs(oldTab) do
		if newTab[k] == nil then
			exceptTab[k] = true
		elseif type(v) ~= type(newTab[k]) then
			exceptTab[k] = true
		elseif type(v) == "table" and type(newTab[k]) == "table" then
			exceptTab[k] = tableUtil.getExceptTab(v, newTab[k])
		end
	end
	return next(exceptTab) and exceptTab or nil
end
function tableUtil.diff(oldTab, newTab)
	if not tableUtil.getExceptTab(oldTab, newTab) then
		tableUtil = tableUtil.getExceptTab(oldTab, newTab)
	end
	if not tableUtil.getMergeTab(oldTab, newTab) then
		tableUtil = tableUtil.getMergeTab(oldTab, newTab)
	end
	return tableUtil.getExceptTab(oldTab, newTab), (tableUtil.getMergeTab(oldTab, newTab))
end
function tableUtil.getAddTab(oldTab, newTab)
	local _ENV, addTab
	for k, v in pairs(newTab) do
		if oldTab[k] == nil then
			addTab[k] = v
		elseif type(v) == "table" and type(oldTab[k]) == "table" then
			addTab[k] = tableUtil.getAddTab(oldTab[k], v)
		end
	end
	return next(addTab) and addTab or nil
end
function tableUtil.getRemoveTab(oldTab, newTab)
	local _ENV, removeTab
	for k, v in pairs(oldTab) do
		if newTab[k] == nil then
			removeTab[k] = v
		elseif type(v) == "table" and type(newTab[k]) == "table" then
			removeTab[k] = tableUtil.getRemoveTab(v, newTab[k])
		end
	end
	return next(removeTab) and removeTab or nil
end
function tableUtil.replaceKey(tab, replaceKeyMap)
	if type(tab) ~= "table" or type(replaceKeyMap) ~= "table" then
		return nil
	end
	local _ENV, newTab
	for k, v in pairs(tab) do
		local vtype = type(v)
		if vtype == "thread" or vtype == "userdata" then
			newTab[k] = v
		elseif vtype == "table" then
			local key = replaceKeyMap[k] or k
			newTab[key] = tableUtil.replaceKey(v, replaceKeyMap)
		else
			local key = replaceKeyMap[k] or k
			newTab[key] = v
		end
	end
	return newTab
end
return tableUtil
