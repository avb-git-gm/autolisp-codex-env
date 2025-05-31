(defun set-drawing-units ()
  (setvar "INSUNITS" 1)
  (setvar "LUNITS" 2)
  (setvar "LUPREC" 3)
  (princ "\nDrawing units set to Inches + Decimal + 0.000 precision.")
)

(defun update-dimstyle (dimsty txtsize arrowsz)
  ;; Create or update style
  (if (not (tblsearch "DIMSTYLE" dimsty))
    (progn
      (command "._dimstyle" "_restore" "Standard")
      (command "._dimstyle" "_save" dimsty)
      (princ (strcat "\nCreated dimension style: " dimsty))
    )
    (princ (strcat "\nUpdating dimension style: " dimsty))
  )

  ;; Set suffix BEFORE restoring to bake it into the style definition
  (setvar "DIMPOST" "\"")
  (command "._dimstyle" "_restore" dimsty)

  ;; Style settings
  (setvar "DIMTXT" txtsize)
  (setvar "DIMASZ" arrowsz)
  (setvar "DIMEXE" 0.125)
  (setvar "DIMEXO" 0.0625)
  (setvar "DIMCLRD" 256)
  (setvar "DIMCLRE" 256)
  (setvar "DIMCLRT" 256)
  (setvar "DIMTIH" 1)
  (setvar "DIMTOH" 0)
  (setvar "DIMSE1" 0)
  (setvar "DIMSE2" 0)
  (setvar "DIMDLI" 0.375)
  (setvar "DIMUNIT" 2)
  (setvar "DIMLUNIT" 2)
  (setvar "DIMDEC" 3)
  (setvar "DIMZIN" 8)
  (setvar "DIMALT" 0)

  ;; Force session to sync with style
  (command "._dimstyle" "_restore" dimsty)
  (princ (strcat "\nStyle '" dimsty "' updated and restored cleanly."))
)

(defun clear-dim-object-overrides (stylename / ss i obj)
  (setq ss (ssget "_X" '((0 . "DIMENSION"))))
  (if ss
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq obj (vlax-ename->vla-object (ssname ss i)))
        (vla-put-StyleName obj stylename)
        (vla-put-TextOverride obj "")
        (vla-put-TextPrefix obj "")
        (vla-put-TextSuffix obj "")
        (setq i (1+ i))
      )
      (command "REGENALL")
      (princ (strcat "\nAll dimension objects reset to style: " stylename))
    )
    (princ "\nNo dimensions found.")
  )
)

(defun apply-dim-style-clean (stylename txtsize arrowsz)
  (update-dimstyle stylename txtsize arrowsz)
  (clear-dim-object-overrides stylename)
)

(defun c:SETU () (set-drawing-units))
(defun c:FDIMA () (apply-dim-style-clean "F-DIM-A" 0.125 0.09))
(defun c:FDIMB () (apply-dim-style-clean "F-DIM-B" 0.16  0.13))
(defun c:FDIMD () (apply-dim-style-clean "F-DIM-D" 0.22  0.18))


(defun c:FDIMGUI ()
  (princ "\nLaunching FDIM GUI... (This placeholder assumes .NET form will be loaded via NETLOAD)")
)
