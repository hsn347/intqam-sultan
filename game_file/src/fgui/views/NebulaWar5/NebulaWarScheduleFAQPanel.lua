local nebulaWarRead = include("nebulaWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarScheduleFAQPanel = class("NebulaWarScheduleFAQPanel", baseFguiPanel)
function NebulaWarScheduleFAQPanel:ctor(...)
	self.isLRU = true
	NebulaWarScheduleFAQPanel.super.ctor(self, ...)
	print("NebulaWarScheduleFAQPanel:ctor", self.viewName)
end
function NebulaWarScheduleFAQPanel:onInit()
	print("=======NebulaWarScheduleFAQPanel:onInit")
	self.fields.Panel_bg:setString(i18n("nebula_war_text_0637"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaWarScheduleFAQPanel:endShow()
	print("=======NebulaWarScheduleFAQPanel:endShow")
	local totalRound = 4
	self.fields.List:setNumItems(totalRound)
	self.fields.List:scrollToView(0)
end
function NebulaWarScheduleFAQPanel:onItemRenderer(index, obj)
	print("==NebulaWarScheduleFAQPanel:onItemRenderer==", index)
	local _fields = fguiHelper.get_fields(obj)
	local round = index + 1
	local roundName = nebulaWarRead.getRoundName(round)
	_fields.Label_title:setString(roundName)
	if round == 1 then
		_fields.Text_des:setString(i18n("nebula_war_text_0630"))
	elseif round == 2 then
		_fields.Text_des:setString(i18n("nebula_war_text_0633"))
	elseif round == 3 then
		_fields.Text_des:setString(i18n("nebula_war_text_0634"))
	elseif round == 4 then
	end
	if _fields.List then
		local key1 = "nebula_war_text_0626"
		local key2 = "nebula_war_text_0627"
		nebulaWarRead, _UPVALUE2_, _ENV, _ENV = i18n("nebula_war_text_0634")
		nebulaWarRead, i18n("nebula_war_text_0634")[1] = 1, 1
		;(1)[1] = 1
		nebulaWarRead, _UPVALUE2_, i18n("nebula_war_text_0634")[1], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		nebulaWarRead, _UPVALUE2_, i18n("nebula_war_text_0634")[1], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		nebulaWarRead, i18n("nebula_war_text_0634")[1] = 0, 0
		;(0)[1] = 0
		nebulaWarRead, _UPVALUE2_, _ENV, i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		nebulaWarRead, _UPVALUE2_, _ENV, i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		nebulaWarRead, i18n("nebula_war_text_0634")[1] = 2, 2
		;(2)[1] = 2
		nebulaWarRead, _UPVALUE2_, i18n("nebula_war_text_0634")[1], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		nebulaWarRead, _UPVALUE2_, i18n("nebula_war_text_0634")[1], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		nebulaWarRead, i18n("nebula_war_text_0634")[1] = 1, 1
		;(1)[1] = 1
		nebulaWarRead, _UPVALUE2_, i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		nebulaWarRead, _UPVALUE2_, i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		nebulaWarRead, i18n("nebula_war_text_0634")[1] = 0, 0
		;(0)[1] = 0
		nebulaWarRead, _UPVALUE2_, _ENV, i18n("nebula_war_text_0634")[3], i18n("nebula_war_text_0634")[3], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		nebulaWarRead, _UPVALUE2_, _ENV, i18n("nebula_war_text_0634")[3], i18n("nebula_war_text_0634")[3], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		_UPVALUE2_, i18n("nebula_war_text_0634")[1] = 3, 3
		;(3)[1] = 2
		;(3)[2] = 1
		_UPVALUE2_, _UPVALUE2_, i18n("nebula_war_text_0634")[1], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		_UPVALUE2_, _UPVALUE2_, i18n("nebula_war_text_0634")[1], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		_UPVALUE2_, i18n("nebula_war_text_0634")[1] = 2, 2
		_UPVALUE2_, i18n("nebula_war_text_0634")[2] = 2, 2
		;(2)[1] = 2
		;(2)[2] = 3
		_UPVALUE2_, _UPVALUE2_, i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		_UPVALUE2_, _UPVALUE2_, i18n("nebula_war_text_0634")[2], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		_UPVALUE2_, i18n("nebula_war_text_0634")[1] = 1, 1
		_UPVALUE2_, i18n("nebula_war_text_0634")[2] = 1, 1
		;(1)[1] = 1
		;(1)[2] = 2
		_UPVALUE2_, _UPVALUE2_, i18n("nebula_war_text_0634")[3], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		_UPVALUE2_, _UPVALUE2_, i18n("nebula_war_text_0634")[3], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		nebulaWarRead, i18n("nebula_war_text_0634")[1] = 1, 1
		nebulaWarRead, i18n("nebula_war_text_0634")[2] = 1, 3
		;(1)[1] = 0
		i18n("nebula_war_text_0634")[4], i18n("nebula_war_text_0634")[4], i18n("nebula_war_text_0634")[1] = i18n("nebula_war_text_0634")
		i18n("nebula_war_text_0634")[4], i18n("nebula_war_text_0634")[4], i18n("nebula_war_text_0634")[2] = i18n("nebula_war_text_0634")
		local config = i18n("nebula_war_text_0634")
		_fields.List:setItemRenderer(function(_index, _obj)
			local _fields = fguiHelper.get_fields(_obj)
			local group = _index + 1
			_fields.light:setVisible(_index % 2 == 1)
			local groupStr = ""
			if round == 4 then
				_ENV = round
				round[1] = i18n("nebula_war_text_0638")
				_ENV = nil
				;(nil).num = 2
				round[2] = i18n("nebula_war_text_0639", nil)
				_ENV = nil
				;(nil).num = 3
				round[3] = i18n("nebula_war_text_0639", nil)
				_ENV = nil
				;(nil).num = 4
				local round[4], config = i18n("nebula_war_text_0639", nil), round
				groupStr = config[group]
			else
				_ENV = "nebula_war_text_0639"
				;("nebula_war_text_0639").num = group
				groupStr = i18n("nebula_war_text_0631", "nebula_war_text_0639")
			end
			_fields.Text_group:setString(groupStr .. [[

VS]])
			local cfg = config[round][group]
			local cfg1, cfg2 = cfg[1], cfg[2]
			_ENV = nil
			;(nil).num = cfg1[1]
			local str1 = i18n("nebula_war_text_0626", nil)
			if cfg1[2] then
				_ENV = nil
				;(nil).num = cfg1[2]
				str1 = str1 .. "\n" .. i18n("nebula_war_text_0627", nil)
			end
			_fields.Text_group1:setString(str1)
			_ENV = str1
			str1.num = cfg2[1]
			local str2 = i18n("nebula_war_text_0626", str1)
			if cfg2[2] then
				_ENV = cfg1[2]
				cfg1[2].num = cfg2[2]
				str2 = str2 .. "\n" .. i18n("nebula_war_text_0627", cfg1[2])
			end
			_fields.Text_group2:setString(str2)
			local textH = math.max(_fields.Text_group1:getHeight(), _fields.Text_group2:getHeight())
			_obj:setHeight(textH + 35)
		end)
		local num = #config[round] or 0
		_fields.List:setNumItems(num)
		_fields.List:resizeToFit(num)
	end
end
return NebulaWarScheduleFAQPanel
