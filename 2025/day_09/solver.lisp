(require :uiop)

(defvar input
        (map 'list
            #'(lambda (line)
                (let ((xy (map
                              'list
                              #'parse-integer
                            (uiop:split-string line :separator ","))))
                  (cons (car xy) (car (cdr xy)))))
          (uiop:read-file-lines (nth 1 *posix-argv*))))


(defun x (p) (car p))
(defun y (p) (cdr p))

(defun part-1 ()
  (reduce #'max (apply #'concatenate 'list
                  (loop for point1 in input for i from 0 collect
                          (loop for point2 in (subseq input (+ i 1)) collect
                                  (* (+ 1 (abs (- (x point1) (x point2))))
                                     (+ 1 (abs (- (y point1) (y point2)))))))) :initial-value 0))

;; Approach for checking if rectangle in polygon: https://github.com/mgtezak/Advent_of_Code/blob/master/2025/09/p2.py
(defun in-polygon (point1 point2)
  (loop for point3 in input
        for point4 in (concatenate 'list (cdr input) (list (car input)))
        do
          (if (and
               (> (max (x point3) (x point4)) (min (x point1) (x point2)))
               (< (min (x point3) (x point4)) (max (x point1) (x point2)))
               (> (max (y point3) (y point4)) (min (y point1) (y point2)))
               (< (min (y point3) (y point4)) (max (y point1) (y point2))))
              (return-from in-polygon nil)))
  t)

(defun part-2 ()
  (let ((area-descending-rectangles
         (sort (apply #'concatenate 'list
                 (loop for point1 in input
                       for i from 0
                       collect
                         (loop for point2 in (subseq input (+ i 1))
                               collect
                                 (list
                                  (* (+ 1 (abs (- (x point1) (x point2))))
                                     (+ 1 (abs (- (y point1) (y point2)))))
                                  point1
                                  point2))))
             #'(lambda (a b) (> (car a) (car b))))))
    (loop for (size point1 point2) in area-descending-rectangles do
            (if
             (in-polygon point1 point2)
             (return-from part-2 size)))))

(format t "Part 1: ~d~%" (part-1))
(format t "Part 2: ~d~%" (part-2))
