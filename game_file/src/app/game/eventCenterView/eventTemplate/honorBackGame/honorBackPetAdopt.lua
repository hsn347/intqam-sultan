local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
local honorBackPetAdopt = class("honorBackPetAdopt", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("honorBackPetAdopt")
	end
	return target
end)
function honorBackPetAdopt:ctor()
	self.enableTouchCloseSelf = true
	self.isCantCloseByReturn = true
	self:initWidget()
	self:initData()
end
function honorBackPetAdopt:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.Text_des:setString(i18n("return_lcks_text_001"))
	self.Button_adopt:setTitleText(i18n("return_lcks_text_002"))
	self.Button_adopt:addTouchEventListener(handler(self, self.btnAdoptClick))
end
function honorBackPetAdopt:initData()
	self:createSpineCat()
end
function honorBackPetAdopt:btnAdoptClick(button, touchType)
	if touchType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self)
		friendPetCtrl:sendReqAdopt()
	end
end
function honorBackPetAdopt:createSpineCat(...)
	local spine_cat = sp.SkeletonAnimation:create("spine/lingmao_youmao.skel", "spine/lingmao_youmao.atlas", 1)
	spine_cat:setAnimation(0, "animation", true)
	spine_cat:setPosition(cc.p(0, -80))
	spine_cat:addTo(self.Node_cat, -1)
end
return honorBackPetAdopt
