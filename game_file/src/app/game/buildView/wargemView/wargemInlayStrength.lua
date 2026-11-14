local gametop = gModuleMgr.getObject("gametop")
local warGemCtrl = gametop.playertop_:getModule("warGemCtrl")
local wargemltCtrl = include("warGemltCtrl")
local wargemResRead = include("wargemResRead")
local ESI = require_data("enchantment_stone_intensify", true)
local MAX_LV = table.nums(ESI.data)
local wargemInlayStrength = class("wargemInlayStrength", function()
	return SoraDCreateTouchPanel("wargemInlayStrength")
end)
function wargemInlayStrength:ctor()
	self.needResCount = nil
	self.itemUseSlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	self.labelDenominator = SoraDGetChildByName(self, "Text_denominator")
	self.btnUse = SoraDGetChildByName(self, "Button_use")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelResNeed = SoraDGetChildByName(self, "Text_resNeed")
	self.node_need = SoraDGetChildByName(self, "Node_need")
	self.node_next = SoraDGetChildByName(self, "Node_next")
	self.labelCur = SoraDGetChildByName(self, "Text_cur")
	self.labelNext = SoraDGetChildByName(self, "Text_next")
	self.arrow = SoraDGetChildByName(self, "frame_arrow")
	self.labelBtnName = SoraDGetChildByName(self, "Text_btn_name")
	self.labelBtnName:setString(i18n("common_text_1340"))
	self.btnUse:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.itemUseSlider:setSliderCallBack(handler(self, self.sliderCallBack))
	self.tableItemData, _ENV = self.itemUseSlider.setSliderCallBack, self.itemUseSlider.setSliderCallBack
end
function wargemInlayStrength:setHandle(handle)
	self.handle = handle
end
function wargemInlayStrength:setLabelHandle(handle)
	self.labelHandle = handle
end
function wargemInlayStrength:sliderCallBack(value)
	self.curValue = value
	self:refreshView()
end
function wargemInlayStrength:initData(gemItemID, posIdx, otherData)
