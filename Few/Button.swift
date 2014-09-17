//
//  Button.swift
//  Few
//
//  Created by Josh Abernathy on 8/1/14.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

import Foundation
import AppKit

public class Button<S>: Element {
	private var title: String

	private var button: NSButton?

	private let trampoline = TargetActionTrampoline()

	public convenience init(title: String, fn: S -> S) {
		self.init(title: title, action: { component in
			component.state = fn(component.state)
		})
	}

	public init(title: String, action: Component<S> -> ()) {
		self.title = title
		super.init()

		self.trampoline.action = { [unowned self] in
			void(action <^> self.getComponent())
		}
	}

	// MARK: Element

	public override func applyDiff(other: Element) {
		if button == nil { return }

		let otherButton = other as Button
		let b = button!
		if title != otherButton.title {
			title = otherButton.title
			b.title = title
		}

		super.applyDiff(other)
	}

	public override func realize(component: Component<S>, parentView: NSView) {
		let button = NSButton(frame: frame)
		button.bezelStyle = .TexturedRoundedBezelStyle
		button.title = title
		button.target = trampoline
		button.action = trampoline.selector
		self.button = button

		super.realize(component, parentView: parentView)
	}

	public override func getContentView() -> NSView? {
		return button
	}
}
