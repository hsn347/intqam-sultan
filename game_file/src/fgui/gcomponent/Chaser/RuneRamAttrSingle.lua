local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local RuneRamAttrSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/RuneRamAttrSingle", RuneRamAttrSingle)
function RuneRamAttrSingle:onInit()
	self.islock = false
	self.maxLock = 2
	self.fields.btn_lock:addClickListener(handler(self, self.onLockClick))
	self.fields.btn_lock:setLockStatus(not self.islock)
	self:fixChildrenPos()
	self.fields.MV_fly:setAllFrameName("dh_baoshi_add_%.2d.png", 1)
	self.fields.MV_fly:setVisible(false)
	self.fields.MV_fly:setScaleX(SoraDFIsRA() and -2 or 2)
end
function RuneRamAttrSingle:onShow()
end
function RuneRamAttrSingle:playFly()
	self.fields.MV_fly:setVisible(true)
	self.fields.MV_fly:setPlaySettings(0, -1, 1)
end
function RuneRamAttrSingle:initData(data, index, isNew, isReview, lockList, rid)
