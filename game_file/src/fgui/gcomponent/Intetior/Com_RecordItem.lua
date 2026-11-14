local intetiorDef = include("intetiorDef")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local mailFunctions = include("mailFunctions")
local baseComponent = require("fgui.base.baseComponent")
local Com_RecordItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/Com_RecordItem", Com_RecordItem)
function Com_RecordItem:onInit()
	self:fixChildrenPos()
end
function Com_RecordItem:onShow()
end
function Com_RecordItem:initData(info, type)
	dump(info, "info")
	if type == 1 then
		local lord = mailFunctions:getWrappedName(_q(info.toAllianceAbb), info.toName)
		local name = mailFunctions:getWrappedName(_q(info.kingAllianceAbb), info.kingName)
		_ENV = nil
		;(nil).name = name
		;(nil).lord = lord
		self.fields.Text_info:setString(i18n("parliament_text_70", nil))
	else
		local kid = lordInfoCtrl:getMapSourceKid()
		if kid == info.winKid then
			_ENV = i18n("parliament_text_70", nil)
			i18n("parliament_text_70", nil).serves = info.loseKingdomName
			self.fields.Text_info:setString(i18n("parliament_text_69", i18n("parliament_text_70", nil)))
		else
			_ENV = i18n("parliament_text_69", i18n("parliament_text_70", nil))
			i18n("parliament_text_69", i18n("parliament_text_70", nil)).serves = info.winKingdomName
			self.fields.Text_info:setString(i18n("parliament_text_68", i18n("parliament_text_69", i18n("parliament_text_70", nil))))
		end
	end
	self.fields.Text_time:setString(_G.SoraDConverTimeStr(info.t))
	if not info.resMap then
		local _ENV, resMap = info.resMap, info.resMap
	end
	for _, v in pairs(intetiorDef.RES_KEY) do
		local txtRes = self.fields["Lable_res" .. v]
		local resNum = resMap[v] or 0
		if txtRes then
			txtRes:setString(string.formatnumberthousands(resNum))
			txtRes:setIcon(publicRead.getIcon(v))
		end
	end
end
return Com_RecordItem
