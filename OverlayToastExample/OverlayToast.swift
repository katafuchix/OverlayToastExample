//
//  OverlayToast.swift
//  OverlayToastExample
//
//  Created by cano on 2025/06/27.
//

import SwiftUI

// MARK: - View 拡張: 任意のViewにインラインでトースト通知を表示する
extension View {
    /// Viewの上下いずれかにトーストを重ねて表示する
    func overlayToast(
        alignment: Alignment,        // 自身（self）の整列位置
        config: OverlayToastConfig,   // トーストの表示設定
        isPresented: Bool            // 表示・非表示を制御
    ) -> some View {
        VStack(spacing: 10) {
            // トーストが bottom のときは、元のViewを先に表示
            if config.anchor == .bottom {
                self
                    .compositingGroup()
                    .frame(maxWidth: .infinity, alignment: alignment)
            }

            // トースト表示部分（isPresented=true のとき）
            if isPresented {
                OverlayToastView(config: config)
                    .compositingGroup()
                    .transition(CustomTransition(anchor: config.animationAnchor)) // カスタム遷移
            }

            // トーストが top のときは、元のViewを後に表示
            if config.anchor == .top {
                self
                    .compositingGroup()
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
        }
        .clipped() // 子Viewがはみ出ないように切り取る
    }
}

// MARK: - トースト表示に使うカスタムトランジション
fileprivate struct CustomTransition: Transition {
    var anchor: OverlayToastConfig.OverlayToastAnchor
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .opacity(phase.isIdentity ? 1 : 0) // フェードイン・アウト
            .visualEffect { [phase] content, proxy in
                content
                    .offset(y: offset(proxy, phase: phase)) // 上下方向にスライド
            }
            .clipped() // 他Viewへの干渉を防ぐ
    }
    
    /// トーストを上下方向にスライドさせるためのオフセット計算
    nonisolated func offset(_ proxy: GeometryProxy, phase: TransitionPhase) -> CGFloat {
        let height = proxy.size.height + 10
        return anchor == .top
            ? (phase.isIdentity ? 0 : -height)
            : (phase.isIdentity ? 0 : height)
    }
}

// MARK: - トースト表示設定
struct OverlayToastConfig {
    var icon: String                    // 左アイコン（例: "checkmark.circle"）
    var title: String                   // タイトル（太字）
    var subTitle: String                // サブタイトル（小さめ・灰色）
    var tint: Color                     // アクセントカラー
    var anchor: OverlayToastAnchor = .top        // トーストの表示位置（上 or 下）
    var animationAnchor: OverlayToastAnchor = .top // アニメーション方向（通常は同じ）
    var actionIcon: String              // アクションボタンのアイコン
    var actionHandler: () -> () = { }   // アクションボタンを押したときの処理

    enum OverlayToastAnchor {
        case top
        case bottom
    }
}

// MARK: - トーストの本体ビュー
struct OverlayToastView: View {
    var config: OverlayToastConfig
    
    var body: some View {
        HStack(spacing: 15) {
            // アイコン（左）
            Image(systemName: config.icon)
                .font(.title2)
                .foregroundStyle(config.tint)
            
            // タイトル & サブタイトル
            VStack(alignment: .leading, spacing: 5) {
                Text(config.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                if !config.subTitle.isEmpty {
                    Text(config.subTitle)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer(minLength: 0) // 残り領域を埋める
            
            // アクションボタン（右端の×など）
            Button(action: config.actionHandler) {
                Image(systemName: config.actionIcon)
                    .foregroundStyle(.gray)
                    .contentShape(.rect) // 小さなアイコンでもタップしやすく
            }
        }
        .padding()
        .background {
            ZStack {
                // 背景（全面にベース色）
                Rectangle()
                    .fill(.background)
                
                // 左端のカラーインジケータ
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(config.tint)
                        .frame(width: 5) // 色付きバー
                    
                    Rectangle()
                        .fill(config.tint.opacity(0.15)) // わずかなグラデーション風味
                }
            }
        }
        .contentShape(.rect)
        .lineLimit(1) // 1行に制限（レイアウト崩れ防止）
    }
}
