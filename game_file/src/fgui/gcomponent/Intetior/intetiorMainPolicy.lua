local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local intetiorRead = include("intetiorRead")
local baseComponent = require("fgui.base.baseComponent")
local intetiorMainPolicy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorMainPolicy", intetiorMainPolicy)
function intetiorMainPolicy:onInit()
	_UPVALUE6_ = nil
	self.resType, (nil)[1] = nil, gIDDef.FOOD
	self.resType, (nil)[2] = nil, gIDDef.WOOD
	self.resType, (nil)[3] = nil, gIDDef.IRON
	self.resType, (nil)[4] = nil, gIDDef.MITHRIL
	self.resType, (nil)[5] = nil, gIDDef.CRYSTAL
	self.resType, (nil)[6] = nil, gIDDef.GOLDBAR
	self.fields.Text_title_name:setString(i18n("parliament_btn_07"))
	self.fields.Text_des:setString(i18n("parliament_text_36"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickRecord))
	self.fields.Button_record:setString(i18n("parliament_btn_16"))
	_ENV = self.fields.Button_record.setString
	_ENV, _ENV, self.fields.Button_record.setString.defaultClick = i18n("parliament_btn_16")
	i18n("parliament_btn_16").title = i18n("parliament_title_06")
	_ENV, self.fields.Button_record[1], i18n("parliament_btn_16").tag = i18n("parliament_btn_16")
	i18n("parliament_btn_16").title = i18n("parliament_title_07")
	self.fields.Button_record.setString.tabsetArray, self.fields.Button_record[2], i18n("parliament_btn_16").tag = self.fields.Button_record, i18n("parliament_btn_16")
	local self.fields.Button_record.setString.callback, tableData = handler(self, self.onClickTab), self.fields.Button_record.setString
	self.fields.com_TabW:initView(tableData)
	self.fields.List_Res:setItemRenderer(handler(self, self.onItemResRender))
end
function intetiorMainPolicy:onShow()
	self:updateResourceInfo()
end
function intetiorMainPolicy:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_RESOURCE_DATA", handler(self, self.updateResourceInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_GOLD_BAR_KINGDOM_CHANGE", handler(self, self.updateResourceInfo))
end
function intetiorMainPolicy:onClickTab(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
end
function intetiorMainPolicy:onClickRecord()
	SoraDPlaySound()
	uiManager:show("intetiorPolicyRecord")
end
function intetiorMainPolicy:updateResourceInfo()
	self.tableRescources = intetiorCtrl:getKingdomResource()
	self.fields.List_Res:setNumItems(#self.resType)
end
function intetiorMainPolicy:onItemResRender(index, target)
	local type = self.resType[index + 1]
	target:setString(SoraDConvertNumberWithUnit(self.tableRescources[tostring(type)] or 0))
	target:getController("c1"):setSelectedIndex(index)
	target:fixChildrenPos()
end
return intetiorMainPolicy
