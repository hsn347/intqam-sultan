local coffeeCraftsmanCtrl = SoraDGetCtrl("coffeeCraftsmanCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_coffeePool = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CoffeeCraftsman/Button_coffeePool", Button_coffeePool)
function Button_coffeePool:onInit()
	self.fields.Moive_bubble:setAllFrameName("dh_xiaguxb_%02d.png")
end
function Button_coffeePool:onShow()
end
function Button_coffeePool:initData()
	local hasChooseAward = coffeeCraftsmanCtrl:hasPoolAward()
	self.controllers.Ctrl_status:setSelectedIndex(hasChooseAward and 0 or 1)
end
function Button_coffeePool:updateGuide()
	local isGuide = coffeeCraftsmanCtrl:getPoolGuide()
	self.fields.Effect_finger:setVisible(isGuide)
end
return Button_coffeePool
