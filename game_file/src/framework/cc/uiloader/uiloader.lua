local packageManager = require("fgui.base.packageManager")
local uiloader = class("uiloader")
function uiloader:ctor()
end
function uiloader:load(file_path)
	local arr = string.split(file_path, "/")
	local pkg_name = table.concat(arr, "_", 1, #arr - 1)
	local com_name = string.match(arr[#arr], "([%w_]+).csb")
	print("cc.uiloader.load", file_path, pkg_name, com_name)
	local _ENV, dicPackages = print, print
	packageManager:addPackageAndDependencies(pkg_name, dicPackages)
	local obj = fgui.UIPackage.CreateObject1(pkg_name, com_name)
	if not obj then
		for k, _ in pairs(dicPackages) do
			packageManager:removePackage(k)
		end
		dicPackages, _ENV = pairs(dicPackages)
		local old_pkg_name = pkg_name
		pkg_name = string.gsub(pkg_name, "^ccsFiles_([^e][^n][^_])", "ccsFiles_en_%1")
		if old_pkg_name ~= pkg_name then
			print_error("临时加载英文版", pkg_name)
			packageManager:addPackageAndDependencies(pkg_name, dicPackages)
			obj = fgui.UIPackage.CreateObject1(pkg_name, com_name)
			if not obj then
				print_error("创建英文版失败", pkg_name)
				for k, _ in pairs(dicPackages) do
					packageManager:removePackage(k)
				end
			end
		end
	end
	if obj then
		obj.__dicPackages__ = dicPackages
		obj.__csb_file_path__ = file_path
		obj:setOnRemoveDicPackages(function()
			if obj.__dicPackages__ then
				for k, v in pairs(obj.__dicPackages__) do
					packageManager:removePackage(k)
				end
			end
			obj.__dicPackages__ = nil
		end)
	end
	return obj
end
return uiloader
