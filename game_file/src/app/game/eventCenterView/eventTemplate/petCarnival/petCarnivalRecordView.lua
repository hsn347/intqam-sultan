local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = gametop.playertop_:getModule("petCarnivalCtrl")
local petCarnivalRecordView = class("petCarnivalRecordView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("petCarnivalRecordView")
	end
	return target
end)
function petCarnivalRecordView:ctor()
	self.commonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ScrollView_item = SoraDGetChildByName(self, "ScrollView_item")
	self.ScrollView_item = include("commonAutoScrollList").new(self.ScrollView_item)
	self.ScrollView_item:setSingleCCS("petCarnivalRecordItem")
	self.Text_no = SoraDGetChildByName(self, "Text_no")
	self.Text_no:setString(i18n("god_beast_text_16"))
	self.Text_no:setVisible(false)
	self.text_tip = SoraDGetChildByName(self, "text_tip")
	self.Image_1 = SoraDGetChildByName(self, "Image_1")
	self.Image_1:setVisible(true)
	if self.text_tip then
		self.text_tip:setString(i18n("parliament_text_11"))
	end
	self.commonPopBox:setTitleName(i18n("luckyFlip_btn_02"))
	petCarnivalCtrl:reqInitData()
	self:fitDevice()
end
function petCarnivalRecordView:fitDevice(...)
	local dis = display.height - 960
	if 0 < dis then
	elseif dis == 0 then
	else
		self.Center_Node:setScale(0.9)
		self.Center_Node:setPositionX(40)
	end
end
function petCarnivalRecordView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_PETCARNIVAL_INIT", handler(self, self.initData))
end
function petCarnivalRecordView:initWidget()
end
function petCarnivalRecordView:initData()
	local data = petCarnivalCtrl:getRecord()
	data = self:reverseTable(data)
	if #data == 0 then
		self.Text_no:setVisible(true)
	end
	petCarnivalCtrl = nil
	;(nil).scroll = self.ScrollView_item
	;(nil).view = self
	self.ScrollView_item:updateScrollView(cc.size(538, 297), data, 1, nil)
end
function petCarnivalRecordView:reverseTable(tab)
	local _ENV, tmp
	local tabClone = clone(tab)
	for i = 1, #tabClone do
		tmp[i] = table.remove(tabClone)
	end
	return tmp
end
return petCarnivalRecordView
