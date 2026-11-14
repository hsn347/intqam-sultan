local nebulaKingCtrl = SoraDGetCtrl("nebulaKingCtrl")
local nebulaKingRead = include("nebulaKingRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local testXYBZPanel = class("testXYBZPanel", baseFguiPanel)
function testXYBZPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("testXYBZPanel:ctor", self.viewName)
	self.content = ""
end
function testXYBZPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function testXYBZPanel:onInit()
	print("=======testXYBZPanel:onInit")
	_UPVALUE2_, _UPVALUE4_ = "=======testXYBZPanel:onInit", print
	_UPVALUE2_, ("=======testXYBZPanel:onInit")[1] = "reqInit", "reqInit"
	_UPVALUE2_, ("=======testXYBZPanel:onInit")[2] = "reqInit", function()
		nebulaKingCtrl:sendReqInit()
	end
	_UPVALUE2_, ("reqInit")[1] = "reqStageRank", "reqStageRank"
	_UPVALUE2_, ("reqInit")[2] = "reqStageRank", function()
		nebulaKingCtrl:sendReqStageRank()
	end
	_UPVALUE2_, ("reqStageRank")[1] = "reqTotalRank", "reqTotalRank"
	_UPVALUE2_, ("reqStageRank")[2] = "reqTotalRank", function()
		nebulaKingCtrl:sendReqTotalRank()
	end
	;("reqTotalRank")[1] = "reqhistoryRank"
	;("reqTotalRank")[2] = function()
		nebulaKingCtrl:sendReqHistoryRank()
	end
	self.data, print[1] = print, "=======testXYBZPanel:onInit"
	self.data, print[2] = print, "reqInit"
	self.data, print[3] = print, "reqStageRank"
	self.data, print[4] = print, "reqTotalRank"
	self.fields.Text_title:setString("XingYunBaZhu CeShi")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_clear:addClickListener(handler(self, self.onClickClear))
end
function testXYBZPanel:onClickClear()
	self.content = ""
	self:updateText()
end
function testXYBZPanel:updateText()
	print("content==", self.content)
	self.fields.Label_content:setString(self.content)
end
local t2s = function(root)
	if not (DEBUG > 0) or type(root) ~= "table" then
		return tostring(root)
	end
	_ENV = tostring
	local tostring[root], cache = ".", tostring
	local function _dump(t, space, name)
		local _ENV, temp
		for k, v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				table.insert(temp, "+" .. key .. " {" .. cache[v] .. "}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				table.insert(temp, "+" .. key .. _dump(v, space .. (next(t, k) and "|" or " ") .. string.rep(" ", #key), new_key))
			else
				table.insert(temp, "+" .. key .. " [" .. tostring(v) .. "]")
			end
		end
		return table.concat(temp, "\n" .. space)
	end
	return _dump(root, "", "")
end
function testXYBZPanel:addContent(data)
	local s = t2s(data)
	self.content = self.content .. "\n" .. s
	self:updateText()
end
function testXYBZPanel:onItemRenderer(index, obj)
	local info = self.data[index + 1]
	obj:setString(info[1])
	obj:addClickListener(info[2])
end
function testXYBZPanel:onShow()
	print("=======testXYBZPanel:onShow")
	self.fields.List:setNumItems(#self.data)
end
return testXYBZPanel
