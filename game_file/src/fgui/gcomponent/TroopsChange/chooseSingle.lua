local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local chooseSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TroopsChange/chooseSingle", chooseSingle)
function chooseSingle:onInit()
	self:fixChildrenPos()
	self.fields.btn_Choose:setString(i18n("treasure_crystal_btn_02"))
	self.fields.btn_Choose:addClickListener(handler(self, self.onClickChoose))
end
function chooseSingle:initData(index, data)
	self.index = index
	self.data = data
	self.ownNum = publicUtil.getCount(data.id)
	if self.ownNum < self.data.count then
		self.fields.btn_Choose:setGrayed(true)
	else
		self.fields.btn_Choose:setGrayed(false)
	end
	self.fields.com_item:initData(data.id, data.count)
	self.fields.com_item:setNum(self.ownNum, data.count)
	self.fields.text_Name:setString(publicRead.getName(data.id))
end
function chooseSingle:setHandle(handler)
	self.handlBack = handler
end
function chooseSingle:onClickChoose()
	SoraDPlaySound()
	if self.ownNum < self.data.count then
		SoraDShowMsgTip(i18n("armyExchange_text_017"))
		return
	end
	if self.handlBack then
		self.handlBack(self.index)
	end
end
return chooseSingle
