local gametop = gModuleMgr.getObject("gametop")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = gametop.playertop_:getModule("equipmentCtrl")
local EquipPopShowView = class("equipPopShowView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipPopShowView")
	end
	return target
end)
_ENV = "equipPopShowView"
;("equipPopShowView")[0] = cc.c3b(255, 255, 255)
;("equipPopShowView")[1] = cc.c3b(0, 190, 30)
;("equipPopShowView")[2] = cc.c3b(0, 185, 255)
;("equipPopShowView")[3] = cc.c3b(255, 0, 255)
local ("equipPopShowView")[4], txtColor = cc.c3b(255, 190, 60), "equipPopShowView"
function EquipPopShowView:ctor()
	self.maxW = 0
	self.tableAttrLabel, _ENV, self.tableEquipData, (nil).show, _ENV, (nil).data, _ENV, _ENV, self.totalH = nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.tableAttrLabel[1] = SoraDGetChildByName(self, "Text_attr")
	self.panelBg = SoraDGetChildByName(self, "Panel_bg")
	self.suitBg = SoraDGetChildByName(self, "suit_attr")
	self.nodeTemplate = SoraDGetChildByName(self.suitBg, "node_single")
	self.txtTwoResult = SoraDGetChildByName(self.suitBg, "txt_twoSuitResult")
	self.txtFourResult = SoraDGetChildByName(self.suitBg, "txt_fourSuitResult")
	self.txtSixResult = SoraDGetChildByName(self.suitBg, "txt_sixSuitResult")
	self.txtTwoAttrResult = SoraDGetChildByName(self.suitBg, "txt_twoResult")
	self.txtFourAttrResult = SoraDGetChildByName(self.suitBg, "txt_fourResult")
	self.txtSixAttrResult = SoraDGetChildByName(self.suitBg, "txt_sixResult")
	self.imageTwoAttrResult = SoraDGetChildByName(self.suitBg, "image_twoResult")
	self.imageFourAttrResult = SoraDGetChildByName(self.suitBg, "image_fourResult")
	self.imageSixAttrResult = SoraDGetChildByName(self.suitBg, "image_sixResult")
	self.frameTwoAttr = SoraDGetChildByName(self.suitBg, "frame_suitTwo")
	self.frameFourAttr = SoraDGetChildByName(self.suitBg, "frame_suitFour")
	self.frameSixAttr = SoraDGetChildByName(self.suitBg, "frame_suitSix")
	if SoraDFIsRA() then
		self.frameTwoAttr:setPositionX(428)
		self.txtTwoAttrResult:setPositionX(400)
		self.frameFourAttr:setPositionX(428)
		self.txtFourAttrResult:setPositionX(400)
		self.frameSixAttr:setPositionX(428)
		self.txtSixAttrResult:setPositionX(400)
	end
end
function EquipPopShowView:initData(equipData, showData, wearEquipList)
