local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local sultansBackRead = include("sultansBackRead")
local publicRead = include("publicRead")
local sultansBackRebateHelpView = class("sultansBackRebateHelpView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sultansBackRebateHelpView")
	end
	return target
end)
function sultansBackRebateHelpView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_3578"))
	self.txtTitleNormal = SoraDGetChildByName(self, "Text_title_normal")
	self.imgLine = SoraDGetChildByName(self, "Image_line")
	self.txtTitleBuff = SoraDGetChildByName(self, "Text_title_buff")
	self.txtTitleBuffInfo = SoraDGetChildByName(self, "Text_title_buff_info")
	self.txtTitleItem = SoraDGetChildByName(self, "Text_title_item")
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size_item")
	self.nodeAward = SoraDGetChildByName(self, "Node_award")
	self.nodeItem = SoraDGetChildByName(self, "Node_item")
	self.nodeContentBuff = SoraDGetChildByName(self, "Node_content_buff")
	self.nodeContentItem = SoraDGetChildByName(self, "Node_content_item")
	self.nodeSingleBuff = SoraDGetChildByName(self, "Node_buff_single")
	self.nodeSingleBuff:setVisible(false)
	self.nodeSingleItem = SoraDGetChildByName(self, "Node_item_single")
	self.nodeSingleItem:setVisible(false)
	self.txtTitleBuff:setString(i18n("back_recharge_text08"))
	self.txtTitleItem:setString(i18n("back_recharge_text21"))
	self:initView()
end
function sultansBackRebateHelpView:initView()
	self.boxData = sultansBackRead.getBackRechargeCfg()
	self.height = 0
	local height = self:initView_normal()
	self.height = self.height + height
	height = self:initView_buff()
	self.height = self.height + height
	height = self:initView_item()
	self.height = self.height + height
	height = math.max(self.scroll:getContentSize().height, self.height)
	self.scroll:setInnerContainerSize(cc.size(640, height))
	self.nodeAward:setPositionY(height)
end
function sultansBackRebateHelpView:initView_normal()
	self.txtTitleNormal:setString(i18n("back_recharge_text04"))
	return 95
end
function sultansBackRebateHelpView:initView_buff()
	self.txtTitleBuffInfo:setString(i18n("back_recharge_text05"))
	local height = 0
	local i = 0
	for _, v in ipairs(self.boxData) do
		if v.buff and 0 < v.buff then
			local node = self.nodeSingleBuff:clone()
			node:setVisible(true)
			node:addTo(self.nodeContentBuff)
			node:setPositionY(-height)
			height = height + 50
			local buffType = buffltCtrl:getEffectType(v.buff)
			local buffValue = buffltCtrl:getEffect(v.buff)
			local textContent = SoraDGetChildByName(node, "Text_content")
			SoraDChangeTextToHtml(textContent)
			_ENV = i18n("back_recharge_text05")
			_ENV = buffType
			buffType.color = "#D7C39B"
			i18n("back_recharge_text05").title = SoraDWrapHtmlTagByStyle(buffDesRead.getTitleBase(buffType, true), buffType)
			_ENV = buffType
			buffType.color = "#FFFFFF"
			buffType.i = "true"
			i18n("back_recharge_text05").value = SoraDWrapHtmlTagByStyle(buffDesRead.getTitleValueWithValue(buffType, buffValue), buffType)
			textContent:setString(i18n("common_text_3904", i18n("back_recharge_text05")))
			local spBg = SoraDGetChildByName(node, "Image_Bg")
			spBg:setVisible(i % 2 == 0)
			i = i + 1
		end
	end
	return height + 100
end
function sultansBackRebateHelpView:initView_item()
