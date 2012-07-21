{-# OPTIONS --without-K #-}

open import Base
open import Truncation.SphereFillings
open import Topology.Spheres
open import Integers.Integers

module FreeGroup.FreeGroup {i} (A : Set i) where

private
  data #freegroup : Set i where
    #e  : #freegroup
    #·  : A → #freegroup → #freegroup
    #⁻¹· : A → #freegroup → #freegroup

    #top : (f : Sⁿ 2 → #freegroup) → #freegroup

freegroup : Set i
freegroup = #freegroup

e : freegroup
e = #e

_·_ : A → freegroup → freegroup
_·_ = #·

_⁻¹·_ : A → freegroup → freegroup
_⁻¹·_ = #⁻¹·

top : (f : Sⁿ 2 → freegroup) → freegroup
top = #top

postulate  -- HIT
  right-inverse-· : (x : A) (u : freegroup) → x · (x ⁻¹· u) ≡ u
  left-inverse-·  : (x : A) (u : freegroup) → x ⁻¹· (x · u) ≡ u
  rays : (f : Sⁿ 2 → freegroup) (x : Sⁿ 2) → top f ≡ f x

#freegroup-rec : ∀ {j} (P : freegroup → Set j)
  (base : P e)
  (g   : (x : A) (u : freegroup) → P u → P (x · u))
  (g'  : (x : A) (u : freegroup) → P u → P (x ⁻¹· u))
  (gg' : (x : A) (u : freegroup) (t : P u) → transport P (right-inverse-· x u) (g x _ (g' x u t)) ≡ t)
  (g'g : (x : A) (u : freegroup) (t : P u) → transport P (left-inverse-· x u) (g' x _ (g x u t)) ≡ t)
  (top* :  (f : Sⁿ 2 → freegroup) (p : (x : Sⁿ 2) → P (f x)) → P (top f))
  (rays* : (f : Sⁿ 2 → freegroup) (p : (x : Sⁿ 2) → P (f x)) (x : Sⁿ 2) → transport P (rays f x) (top* f p) ≡ p x)
  → ((t : freegroup) → P t)
#freegroup-rec P base g g' gg' g'g top* rays* #e = base
#freegroup-rec P base g g' gg' g'g top* rays* (#· x u) = g x u (#freegroup-rec P base g g' gg' g'g top* rays* u)
#freegroup-rec P base g g' gg' g'g top* rays* (#⁻¹· x u) = g' x u (#freegroup-rec P base g g' gg' g'g top* rays* u)
#freegroup-rec P base g g' gg' g'g top* rays* (#top f) = top* f (λ x → #freegroup-rec P base g g' gg' g'g top* rays* (f x))

#freegroup-rec-nondep : ∀ {j} (B : Set j)
  (base : B)
  (g   : A → B → B)
  (g'  : A → B → B)
  (gg' : (x : A) (u : B) → (g x (g' x u)) ≡ u)
  (g'g : (x : A) (u : B) → (g' x (g x u)) ≡ u)
  (top* :  (f : Sⁿ 2 → freegroup) (p : Sⁿ 2 → B) → B)
  (rays* : (f : Sⁿ 2 → freegroup) (p : Sⁿ 2 → B) (x : Sⁿ 2) → top* f p ≡ p x)
  → freegroup → B
#freegroup-rec-nondep P base g g' gg' g'g top* rays* #e = base
#freegroup-rec-nondep P base g g' gg' g'g top* rays* (#· x u) = g x (#freegroup-rec-nondep P base g g' gg' g'g top* rays* u)
#freegroup-rec-nondep P base g g' gg' g'g top* rays* (#⁻¹· x u) = g' x (#freegroup-rec-nondep P base g g' gg' g'g top* rays* u)
#freegroup-rec-nondep P base g g' gg' g'g top* rays* (#top f) = top* f (λ x → #freegroup-rec-nondep P base g g' gg' g'g top* rays* (f x))

freegroup-rec : ∀ {j} (P : freegroup → Set j)
  (base : P e)
  (g   : (x : A) (u : freegroup) → P u → P (x · u))
  (g'  : (x : A) (u : freegroup) → P u → P (x ⁻¹· u))
  (gg' : (x : A) (u : freegroup) (t : P u) → transport P (right-inverse-· x u) (g x _ (g' x u t)) ≡ t)
  (g'g : (x : A) (u : freegroup) (t : P u) → transport P (left-inverse-· x u) (g' x _ (g x u t)) ≡ t)
  (p : (u : freegroup) → is-set (P u))
  → ((t : freegroup) → P t)
freegroup-rec P base g g' gg' g'g p = #freegroup-rec P base g g' gg' g'g (λ f p₁ → π₁ (u f p₁)) (λ f p₁ → π₂ (u f p₁)) where
  u : _ -- (f : Sⁿ 2 → freegroup) (p : (x : Sⁿ 2) → P (f x)) → filling-dep 2 P f (top f , rays f) p
  u = hlevel-n-has-filling-dep freegroup P 2 (λ f → (top f , rays f))

freegroup-rec-nondep : ∀ {j} (B : Set j)
  (base : B)
  (g   : A → B → B)
  (g'  : A → B → B)
  (gg' : (x : A) (u : B) → (g x (g' x u)) ≡ u)
  (g'g : (x : A) (u : B) → (g' x (g x u)) ≡ u)
  (p : is-set B)
  → freegroup → B
freegroup-rec-nondep B base g g' gg' g'g p = #freegroup-rec-nondep B base g g' gg' g'g (λ _ p → π₁ (u p)) (λ _ p → π₂ (u p)) where
  u : _
  u = hlevel-n-has-n-spheres-filled 2 _ p

-- Actual free group

-- freegroup : ⦃ p : is-set A ⦄ → Set _
-- freegroup = τ 2 freegroup

--freegroup-naive-rec-nondep B base g g' gg' g'g set = freegroup-naive-rec (λ _ → B) base (λ x u t → g x t) (λ x u t → g' x t) (λ x u t → trans-nondep (ff' x u) (g x (g' x t)) ∘ gg' x t) (λ x u t → trans-nondep (f'f x u) (g' x (g x t)) ∘ g'g x t) (λ u p x l → {!!})
{-
abstract
  β-nondep : ∀ {i} (A : Set i) (x : A) (p : x ≡ x) → map (circle-rec-nondep A x p) loop ≡ p
  β-nondep A x p = map-dep-trivial (circle-rec-nondep A x p) loop ∘ (whisker-left (! (trans-nondep loop _)) (β (λ _ → A) x (trans-nondep loop _ ∘ p))
    ∘ (! (concat-assoc (! (trans-nondep loop _)) (trans-nondep loop _) p)
    ∘ whisker-right p (opposite-left-inverse (trans-nondep loop _))))
-}
