local FGUIPackageLoader_Instance = CS.Sultan.FGUIPackageLoader.Instance
local _ENV, dicPkgRef
local _ENV, asyncOperation
local pkg_path = ""
_ENV = nil
;(nil).Common = 1
;(nil).Default = 1
;(nil).Base = 1
;(nil).baseFguiPanel = 1
;(nil).NewFonts = 1
local (nil).fonts, commmonPackages = 1, nil
for i = 0, 68 do
	commmonPackages["Resource" .. i] = 1
end
local _ENV, packageManager = (for index), 0
function packageManager:addCommonPackages()
	for pkg_name, _ in pairs(commmonPackages) do
		self:addPackage(pkg_name)
	end
end
function packageManager:isCommonPakage(pkg_name)
	return commmonPackages[pkg_name] ~= nil
end
function packageManager:addPackage(pkg_name)
	self:addRef(pkg_name)
	return FGUIPackageLoader_Instance:AddPackageSync(pkg_path .. pkg_name)
end
function packageManager:addPackageAndDependencies(pkg_name, dicLoaded)
	if not dicLoaded then
		dicLoaded, _ENV = nil, nil
	end
	if dicLoaded[pkg_name] then
		error("packageManager:addPackageAndDependencies already loaded, " .. pkg_name)
	end
	local pkg = self:addPackage(pkg_name)
	if not pkg then
		print_error("addPackage fail", pkg_name)
		return false
	end
	dicLoaded[pkg_name] = 1
	if not self:isCommonPakage(pkg_name) then
		local dependencies = pkg.dependencies
		for _, dep_pkg in pairs(dependencies) do
			if not self:isCommonPakage(dep_pkg) and not dicLoaded[dep_pkg] then
				self:addPackageAndDependencies(dep_pkg, dicLoaded)
			end
		end
	end
	return true
end
function packageManager:addPackageAsync(pkg_name, callback)
	local path = pkg_path .. pkg_name
	local operation = FGUIPackageLoader_Instance:AddPackageAsync(path, function(op)
		if op then
			self:removeOperation(op)
		end
		if callback then
			callback(pkg_name)
		end
	end)
	if operation then
		table.insert(asyncOperation, operation)
	end
	self:addRef(pkg_name)
end
function packageManager:removeOperation(operation)
	for i, v in ipairs(asyncOperation) do
		if v == operation then
			return table.remove(asyncOperation, i)
		end
	end
end
function packageManager:removePackageASync(pkg_name, operation)
	local bFind = false
	if operation then
		local op = self:removeOperation(operation)
		if not op then
			print_error("op not found!", pkg_name)
		end
		operation:Cancel()
	end
	self:removePackage(pkg_name)
end
function packageManager:removePackage(pkg_name)
	local count = dicPkgRef[pkg_name]
	if count then
		count = count - 1
		dicPkgRef[pkg_name] = count
		if count <= 0 then
		end
	else
		FGUIPackageLoader_Instance:RemovePackage(pkg_path .. pkg_name)
	end
end
function packageManager:addRef(pkg_name)
	if dicPkgRef[pkg_name] then
		dicPkgRef[pkg_name] = dicPkgRef[pkg_name] + 1
	else
		dicPkgRef[pkg_name] = 1
	end
end
function packageManager:clearUnusedPackage()
	for k, v in pairs(dicPkgRef) do
		if v <= 0 then
			dicPkgRef[k] = nil
			FGUIPackageLoader_Instance:RemovePackage(pkg_path .. k)
		end
	end
end
function packageManager:clear()
	for k, v in pairs(dicPkgRef) do
		FGUIPackageLoader_Instance:RemovePackage(pkg_path .. k)
	end
	for k, operation in pairs(asyncOperation) do
		operation:Cancel()
	end
	_ENV = (for generator)
	_ENV = {}
end
function packageManager:checkDicPkgRef(pkg_name)
	local count = dicPkgRef[pkg_name]
	return count and 0 < count
end
function packageManager:dumpDicPkgRef()
	dump(dicPkgRef, "==dicPkgRef==")
end
return packageManager
