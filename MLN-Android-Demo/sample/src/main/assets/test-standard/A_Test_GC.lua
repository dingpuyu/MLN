---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by XiongFangyu.
--- DateTime: 2019-07-11 14:56
---

local function loop()
    local all = {}
    for i = 1, 500 do
        all[i] = GCTest()
    end

    for i = 1, 500 do
        all[i] = nil
    end

    all = nil
end


local btn = Label():text('click'):setGravity(Gravity.CENTER):bgColor(Color(255,0,0,1)):width(100):height(50)
window:addView(btn)
btn:onClick(loop)

loop()