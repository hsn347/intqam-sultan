local _ENV, worldMapEffect
function worldMapEffect.createRamadanKingdomEffect(leftTime)
	local node = display.newNode()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_mingxingfuwuqilizi01.plist"
	;(nil).x = -10.5
	_ENV, (nil).pos, (nil).y = nil, nil, 16.3
	;(nil).x = 2.63
	;(nil).scale, (nil).y = nil, 5.47
	_ENV, (nil)[1], (nil).rotate = nil, nil, -1.5
	_ENV, (nil).plist = nil, "et_mingxingfuwuqilizi02.plist"
	;(nil).x = -2.4
	;(nil).pos, (nil).y = nil, -25
	;(nil)[2], (nil).scale = nil, 2.02
	local param_bg
	local et_node_bg = SoraDCreateEffectNode(param_bg)
	et_node_bg:addTo(node, 1)
	local moon = display.newSprite("#dh_starSvr_moon.png")
	moon:addTo(node, 2)
	_ENV, _ENV = moon, moon.addTo
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi03.plist"
	node.x = -16
	_ENV, moon.pos, node.y = node, node, -25
	node.x = 1.76
	_ENV, moon.addTo[1], moon.scale, node.y = moon, moon, node, 1.8
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi04.plist"
	node.x = -0.2
	_ENV, moon.addTo[2], moon.pos, node.y = moon, moon, node, -10.7
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi05.plist"
	node.x = -6
	_ENV, moon.pos, node.y = node, node, -8.5
	node.x = 1.11
	moon.scale, node.y = node, 1.07
	_ENV, moon.addTo[3], moon.rotate = moon, moon, 46.8
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi06.plist"
	node.x = 0.25
	_ENV, moon.addTo[4], moon.pos, node.y = moon, moon, node, -130
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi07.plist"
	node.x = -5.8
	_ENV, moon.pos, node.y = node, node, -62.7
	node.x = 1.13
	moon.scale, node.y = node, 1.26
	_ENV, moon.addTo[5], moon.rotate = moon, moon, 181.4
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi08.plist"
	node.x = -6.9
	_ENV, moon.pos, node.y = node, node, -137
	node.x = 1.8
	_ENV, moon.addTo[6], moon.scale, node.y = moon, moon, node, 1.47
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi09.plist"
	node.x = -24
	_ENV, moon.pos, node.y = node, node, -3
	node.x = 0.93
	moon.scale, node.y = node, 1.25
	_ENV, moon.addTo[7], moon.rotate = moon, moon, 1.95
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi09.plist"
	node.x = 26
	_ENV, moon.pos, node.y = node, node, -30
	node.x = 0.72
	moon.scale, node.y = node, 0.42
	_ENV, moon.addTo[8], moon.rotate = moon, moon, -37.4
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi09.plist"
	node.x = -11
	_ENV, moon.pos, node.y = node, node, 30
	node.x = 0.81
	moon.scale, node.y = node, 0.41
	_ENV, moon.addTo[9], moon.rotate = moon, moon, -33.4
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi10.plist"
	node.x = -24.5
	_ENV, moon.addTo[10], moon.pos, node.y = moon, moon, node, -4
	_ENV, moon.plist = node, "et_mingxingfuwuqilizi11.plist"
	node.x = -5.8
	moon.addTo[11], moon.pos, node.y = moon, node, -12.5
	local param_top = moon.addTo
	local et_node_top = SoraDCreateEffectNode(param_top)
	et_node_top:addTo(node, 3)
	if leftTime and 0 < leftTime then
		local timeBg = display.newSprite("#frame_recharge__sheer_time.png")
		timeBg:setPositionY(50)
		timeBg:addTo(node, 4)
		local timeNode = display.newNode()
		timeNode:setPositionY(50)
		local ramadanTime = ccui.Text:create(i18n("common_text_3109"), "", 20)
		ramadanTime:setTextColor(cc.c4b(255, 245, 230, 255))
		ramadanTime:addTo(timeNode)
		local time = ccui.Text:create("", "", 20)
		time:setTextColor(cc.c4b(255, 245, 230, 255))
		time:setAnchorPoint(cc.p(0, 0.5))
		time:setTextHorizontalAlignment(SoraDFLabelR())
		time:addTo(timeNode)
		time = SoraDCreateTimerLabel(timeNode, time)
		time:beginTime(leftTime)
		SoraDToCenter(timeNode, 5, SoraDFIsRA())
		timeNode:addTo(node, 5)
	end
	return node
end
function worldMapEffect.createFireTimeNode()
	local node = display.newNode()
	local image_fireBg = display.newSprite("#frame_map_07.png")
	image_fireBg:setPosition(cc.p(0, 0))
	image_fireBg:addTo(node)
	_ENV = image_fireBg
	image_fireBg.UILabelType = 2
	image_fireBg.text = "00:00:00"
	image_fireBg.size = 20
	local text_fireTime = cc.ui.UILabel.new(image_fireBg)
	text_fireTime:setAnchorPoint(cc.p(0.5, 0.5))
	text_fireTime:setPosition(cc.p(0, -5))
	text_fireTime:setColor(cc.c3b(255, 255, 255))
	text_fireTime:addTo(node, 9)
	local cutLayer = ccui.Layout:create()
	cutLayer:setAnchorPoint(cc.p(0, 0.5))
	cutLayer:setPosition(cc.p(10, -5))
	cutLayer:setContentSize(cc.size(100, 30))
	cutLayer:setClippingEnabled(true)
	cutLayer:addTo(node, 2)
	local lead = display.newSprite("#frame_fireworks_01.png")
	lead:setPosition(cc.p(45, 15))
	lead:addTo(cutLayer)
	local lead_fire = display.newSprite("#frame_fireworks_02.png")
	lead_fire:setPosition(cc.p(90, 20))
	lead_fire:addTo(cutLayer)
	_ENV, _ENV = lead_fire, lead_fire.addTo
	lead_fire.plist = "et_daohuoso_01.plist"
	_ENV, lead_fire.addTo[1], lead_fire.scale = lead_fire, lead_fire, 0.8
	lead_fire.plist = "et_daohuoso_02.plist"
	lead_fire.addTo[2], lead_fire.scale = lead_fire, 0.4
	local param = lead_fire.addTo
	local et_node = SoraDCreateEffectNode(param)
	et_node:setPosition(cc.p(15, 13.5))
	et_node:addTo(lead_fire)
	_ENV, _ENV = et_node, et_node.addTo
	et_node.x = 90
	et_node.y = 20
	_ENV, et_node.addTo[1], et_node.dt_cut = et_node, et_node, 100
	et_node.x = 85
	et_node.y = 20
	_ENV, et_node.addTo[2], et_node.dt_cut = et_node, et_node, 96
	et_node.x = 80
	et_node.y = 20
	_ENV, et_node.addTo[3], et_node.dt_cut = et_node, et_node, 90
	et_node.x = 75
	et_node.y = 20
	_ENV, et_node.addTo[4], et_node.dt_cut = et_node, et_node, 84
	et_node.x = 70
	et_node.y = 18
	_ENV, et_node.addTo[5], et_node.dt_cut = et_node, et_node, 79
	et_node.x = 65
	et_node.y = 16
	_ENV, et_node.addTo[6], et_node.dt_cut = et_node, et_node, 74
	et_node.x = 60
	et_node.y = 14
	_ENV, et_node.addTo[7], et_node.dt_cut = et_node, et_node, 70
	et_node.x = 55
	et_node.y = 12
	_ENV, et_node.addTo[8], et_node.dt_cut = et_node, et_node, 64
	et_node.x = 50
	et_node.y = 9
	_ENV, et_node.addTo[9], et_node.dt_cut = et_node, et_node, 59
	et_node.x = 45
	et_node.y = 9
	_ENV, et_node.addTo[10], et_node.dt_cut = et_node, et_node, 54
	et_node.x = 40
	et_node.y = 8
	_ENV, et_node.addTo[11], et_node.dt_cut = et_node, et_node, 49
	et_node.x = 35
	et_node.y = 8
	_ENV, et_node.addTo[12], et_node.dt_cut = et_node, et_node, 44
	et_node.x = 30
	et_node.y = 9
	_ENV, et_node.addTo[13], et_node.dt_cut = et_node, et_node, 39
	et_node.x = 25
	et_node.y = 10
	_ENV, et_node.addTo[14], et_node.dt_cut = et_node, et_node, 34
	et_node.x = 20
	et_node.y = 11
	_ENV, et_node.addTo[15], et_node.dt_cut = et_node, et_node, 29
	et_node.x = 15
	et_node.y = 13
	_ENV, et_node.addTo[16], et_node.dt_cut = et_node, et_node, 24
	et_node.x = 10
	et_node.y = 13
	et_node.addTo[17], et_node.dt_cut = et_node, 19
	local fireLeadConfig = et_node.addTo
	function node.init(time)
		local initTime = time
		node = nil
		;(nil)[1] = cca.callFunc(function()
			if time < 0 then
				node:stopAllActions()
				return
			end
			text_fireTime:setString(SoraDConvertSecondToString(time))
			local percent = 1 - time / initTime
			for k, v in ipairs(fireLeadConfig) do
				if percent <= k / #fireLeadConfig then
					lead_fire:setPosition(cc.p(v.x, v.y))
					cutLayer:setContentSize(cc.size(v.dt_cut, 30))
					break
				end
			end
		end)
		;(nil)[2] = cca.delay(1)
		;(nil)[3] = cca.delay(1)
		local seq = cca.seq(nil)
		node:runAction(cca.repeatForever(seq))
	end
	return node
end
return worldMapEffect
